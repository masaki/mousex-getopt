package MouseX::Getopt::OptionTypeMap;

use strict;
use warnings;
use Scalar::Util 1.14 'blessed';
use Carp 'confess';

my %option_type_map = (
    'Bool'      => '!',
    'Str'       => '=s',
    'Int'       => '=i',
    'Num'       => '=f',
    'ArrayRef'  => '=s@',
    'HashRef'   => '=s%',
    'ClassName' => '=s',
);

sub _to_name {
    my ($type_or_name) = @_;
    return blessed $type_or_name ? $type_or_name->name : $type_or_name;
}

sub has_option_type {
    my (undef, $type_or_name) = @_;
    return exists $option_type_map{_to_name($type_or_name)};
}

sub get_option_type {
    my (undef, $type_or_name) = @_;
    if (my $option_type = $option_type_map{_to_name($type_or_name)}) {
        return $option_type;
    }
    else {
        return;
    }
}

sub add_option_type_to_map {
    my (undef, $type_or_name, $spec) = @_;

    (defined $type_or_name and defined $spec)
        or confess 'You must supply both a type name and an option string';

    $option_type_map{_to_name($type_or_name)} = $spec;
}

1;

=head1 NAME

MouseX::Getopt::OptionTypeMap - Storage for the option to type mappings

=head1 METHODS

=head2 has_option_type($name)

=head2 get_option_type($name)

=head2 add_option_type_to_map($name, $spec)

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
