package MouseX::Getopt;

use 5.8.1;
use Mouse::Role;
use MouseX::Getopt::OptionTypeMap;
use Getopt::Long ();

our $VERSION = '0.01';

sub new_with_options {
    my ($class, %params) = @_;

    my %processed = $class->_parse_argv(
        specs  => $class->_attrs_to_specs,
        params => \%params,
    );

    return $class->new(
        %params,    # explicit params to new
        %processed, # params from CLI
    );
}

sub _parse_argv {
    my ($class, %params) = @_;

    local @ARGV = @{ $params{argv} || \@ARGV };
    my $specs = $params{specs};

    my @warn;
    my $options = eval {
        local $SIG{__WARN__} = sub { push @warn, @_ };
        Getopt::Long::GetOptions(\my %options, map { $_->{spec} } values %$specs);
        \%options;
    };
    if (@warn or $@) {
        die join '', grep { defined } @warn, $@;
    }

    my %args = map { $specs->{$_}->{name} => $options->{$_} } keys %$options;
    return %args;
}

sub _attrs_to_specs {
    my $class = shift;

    my $specs = {};
    for my $attr ($class->meta->compute_all_applicable_attributes) {
        my $name = $attr->name;
        next if $name =~ /^_/;

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
constraint defined, it will configure Getopt::Long to handle the option
accordingly.

=head1 METHODS

=head2 new_with_options(%params?)

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Mouse>, L<MooseX::Getopt>, L<Getopt::Long>

=cut
