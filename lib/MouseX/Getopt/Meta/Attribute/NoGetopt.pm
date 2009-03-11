package MouseX::Getopt::Meta::Attribute::NoGetopt;

{
    package # hide from PAUSE
        Mouse::Meta::Attribute::Custom::NoGetopt;
    sub register_implementation { 'MouseX::Getopt::Meta::Attribute::NoGetopt' }
}

use Mouse;

extends 'Mouse::Meta::Attribute';

no Mouse;

1;

=head1 NAME

MouseX::Getopt::Meta::Attribute::NoGetopt - Optional meta attribute for ignoring params

=head1 SYNOPSIS

    package MyApp;
    use Mouse;

    with 'MouseX::Getopt';

    has 'data' => (
        metaclass => 'NoGetopt',
        is        => 'rw',
        isa       => 'Str',
    );

=head1 DESCRIPTION

This module is a custom attribute metaclass for suppressing
C<MouseX::Getopt>'s process to a specific attribute.

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
