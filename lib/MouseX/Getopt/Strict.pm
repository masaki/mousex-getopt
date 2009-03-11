package MouseX::Getopt::Strict;

use Mouse::Role;

with 'MouseX::Getopt';

around '_compute_getopt_attributes' => sub {
    my ($next, $class, @args) = @_;
    my @attrs = $next->($class, @args);
    return grep { $_->isa('MouseX::Getopt::Meta::Attribute::Getopt') } @attrs;
};

no Mouse::Role;

1;

=head1 NAME

MouseX::Getopt::Strict - Only process options with Getopt metaclass

=head1 SYNOPSIS

    package MyApp;
    use Mouse;

    with 'MouseX::Getopt::Strict';

    has 'data' => (
        metaclass => 'Getopt',
        is        => 'rw',
        isa       => 'Str',
    );

=head1 DESCRIPTION

This module is a stricter version of L<MouseX::Getopt>.
This module only processes the attributes
which set C<Getopt> metaclass explicitly.
All other attributes are ignored.

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
