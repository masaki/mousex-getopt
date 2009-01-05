package MouseX::Getopt;

use 5.8.1;
use Mouse::Role;
use Getopt::Long ();

our $VERSION = '0.01';

sub new_with_options {
    my ($class, %params) = @_;

    return $class->new(
        %params, # explicit params to new
        $class->_parse_argv(%params), #" params from CLI
    );
}

sub _parse_argv {
    my ($class, %params) = @_;

    my $options  = $class->_attrs_to_options;
    my %init_arg = map { $_->{name} => $_->{init_arg} } @$options;

    local @ARGV = @{ $params{argv} || \@ARGV };

    my @err;
    my $parsed_options = eval {
        local $SIG{__WARN__} = sub { push @err, @_ };
        Getopt::Long::GetOptions(\my %options, map { $_->{spec} } @$options);
        \%options;
    };
    if (@err or $@) {
        die join '', grep { defined } @err, $@;
    }

    my %args = map { $init_arg{$_} => $parsed_options->{$_} } keys %$parsed_options;
    return %args;
}

sub _attrs_to_options {
    my $class = shift;

    my @options;
    for my $attr ($class->meta->compute_all_applicable_attributes) {
        my $name = $attr->name;
        next if $name =~ /^_/;

        my $spec = $name;
        if ($attr->has_type_constraint) {
            my $type = $attr->type_constraint;
            if ($class->_has_option_type($type)) {
                $spec .= $class->_get_option_type($type);
            }
        }

        $name =~ s/\W/_/g;
        push @options, {
            name     => $name,
            spec     => $spec,
            init_arg => $attr->init_arg,
        };
    }

    \@options;
}

{
    my %typemap = (
        'Bool'     => '!',
        'Str'      => '=s',
        'Int'      => '=i',
        'Num'      => '=f',
        'ArrayRef' => '=s@',
        'HashRef'  => '=s%',
    );

    sub _has_option_type { exists $typemap{$_[1]} }
    sub _get_option_type { $typemap{$_[1]} }
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
