package MouseX::Getopt;

use 5.8.1;
use Mouse::Role;
use MouseX::Getopt::OptionTypeMap;
use Getopt::Long ();

our $VERSION = '0.02';

has 'ARGV'       => ( is => 'ro', isa => 'ArrayRef' );
has 'extra_argv' => ( is => 'ro', isa => 'ArrayRef' );

sub new_with_options {
    my ($class, %params) = @_;

    my %processed = $class->_parse_argv(
        specs  => $class->_attrs_to_specs,
        params => \%params,
    );

    return $class->new(
        ARGV       => $processed{ARGV},
        extra_argv => $processed{extra_argv},
        %params,                  # explicit params to new
        %{ $processed{options} }, # params from CLI
    );
}

sub _parse_argv {
    my ($class, %params) = @_;

    local @ARGV = @{ $params{argv} || \@ARGV };
    my $argv    = [ @ARGV ];
    my $specs   = $params{specs};

    my @warn;
    my $options = eval {
        local $SIG{__WARN__} = sub { push @warn, @_ };
        Getopt::Long::GetOptions(\my %options, map { $_->{spec} } values %$specs);
        \%options;
    };
    if (@warn or $@) {
        die join '', grep { defined } @warn, $@;
    }

    my $extra = [ @ARGV ];
    my %args  = map { $specs->{$_}->{name} => $options->{$_} } keys %$options;

    return (
        options    => \%args,
        ARGV       => $argv,
        extra_argv => $extra,
    );
}

sub _attrs_to_specs {
    my $class = shift;

    my $specs = {};
    for my $attr ($class->meta->compute_all_applicable_attributes) {
        my $name = $attr->name;
        next if $name =~ /^_/;
        next if $name =~ /^(?:ARGV|extra_argv)$/;

        my $spec = $name;
        if ($attr->has_type_constraint) {
            my $type = $attr->type_constraint;
            if (MouseX::Getopt::OptionTypeMap->has_option_type($type)) {
                $spec .= MouseX::Getopt::OptionTypeMap->get_option_type($type);
            }
        }

        $name =~ s/\W/_/g;
        $specs->{$name} = { spec => $spec, name => $attr->init_arg };
    }

    $specs;
}

no Mouse::Role; 1;

=for stopwords DWIM params

=head1 NAME

MouseX::Getopt - A Mouse role for processing command line options

=head1 SYNOPSIS

  # In your class
  package MyApp;
  use Mouse;

  with 'MouseX::Getopt';

  has 'out' => (is => 'rw', isa => 'Str', required => 1);
  has 'in'  => (is => 'rw', isa => 'Str', required => 1);

  # In your script
  #!/usr/bin/perl

  use MyApp;

  my $app = MyApp->new_with_options;

  # On the command line
  % perl myapp_script.pl -in file.input -out file.dump

=head1 DESCRIPTION

This is a role which provides an alternate constructor for creating
objects using parameters passed in from the command line.

This module attempts to DWIM as much as possible with the command line
params by introspecting your class's attributes. It will use the name
of your attribute as the command line option, and if there is a type
constraint defined, it will configure L<Getopt::Long> to handle the
option accordingly.

=head2 Supported Type Constraints

=over 4

=item I<Bool>

A I<Bool> type constraint is set up as a boolean option with
Getopt::Long. So that this attribute description:

  has 'verbose' => (is => 'rw', isa => 'Bool');

would translate into C<verbose!> as a Getopt::Long option descriptor,
which would enable the following command line options:

  % perl myapp_script.pl --verbose
  % perl myapp_script.pl --noverbose

=item I<Int>, I<Float>, I<Str>

These type constraints are set up as properly typed options with
Getopt::Long, using the C<=i>, C<=f> and C<=s> modifiers as appropriate.

=item I<ArrayRef>

An I<ArrayRef> type constraint is set up as a multiple value option
in Getopt::Long. So that this attribute description:

  has 'include' => (
      is      => 'rw',
      isa     => 'ArrayRef',
      default => sub { [] },
  );

would translate into C<include=s@> as a Getopt::Long option descriptor,
which would enable the following command line options:

  % perl myapp_script.pl --include /usr/lib --include /usr/local/lib

=item I<HashRef>

A I<HashRef> type constraint is set up as a hash value option
in Getopt::Long. So that this attribute description:

  has 'define' => (
      is      => 'rw',
      isa     => 'HashRef',
      default => sub { +{} },
  );

would translate into C<define=s%> as a Getopt::Long option descriptor,
which would enable the following command line options:

  % perl myapp_script.pl --define os=linux --define vendor=debian

=back

=head2 Custom Type Constraints

It is possible to create custom type constraint to option spec
mappings if you need them. The process is fairly simple (but a little
verbose maybe). First you create a custom subtype, like so:

  subtype 'ArrayOfInts'
      => as 'ArrayRef'
      => where { scalar (grep { looks_like_number($_) } @$_) };

Then you register the mapping, like so:

  MouseX::Getopt::OptionTypeMap->add_option_type_to_map(
      'ArrayOfInts' => '=i@'
  );

Now any attribute declarations using this type constraint will
get the custom option spec. So that, this:

  has 'nums' => (
      is      => 'ro',
      isa     => 'ArrayOfInts',
      default => sub { [0] },
  );

Will translate to the following on the command line:

  % perl myapp_script.pl --nums 5 --nums 88 --nums 199

=head1 METHODS

=head2 new_with_options(%params?)

This method will take a set of default C<%params> and then collect
params from the command line (possibly overriding those in C<%params>)
and then return a newly constructed object.

If L<Getopt::Long/GetOptions> fails (due to invalid arguments),
C<new_with_options> will throw an exception.

=head1 PROPERTIES

=head2 ARGV

This accessor contains a reference to a copy of the C<@ARGV> array
as it originally existed at the time of C<new_with_options>.

=head2 extra_argv

This accessor contains an arrayref of leftover C<@ARGV> elements that
L<Getopt::Long> did not parse. Note that the real C<@ARGV> is left
unmangled.

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Mouse>, L<Getopt::Long>, L<MooseX::Getopt>

=cut
