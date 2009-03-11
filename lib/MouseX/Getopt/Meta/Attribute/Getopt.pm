package MouseX::Getopt::Meta::Attribute::Getopt;

{
    package # hide from PAUSE
        Mouse::Meta::Attribute::Custom::Getopt;
    sub register_implementation { 'MouseX::Getopt::Meta::Attribute::Getopt' }
}

use Mouse;
use Mouse::Util::TypeConstraints;

extends 'Mouse::Meta::Attribute';

subtype '_MouseX_Getopt_CmdAliases', as 'ArrayRef';

coerce '_MouseX_Getopt_CmdAliases', from 'Str', via { [$_] };

has 'cmd_flag' => (
    is        => 'rw',
    isa       => 'Str',
    predicate => 'has_cmd_flag',
);

has 'cmd_aliases' => (
    is        => 'rw',
    isa       => '_MouseX_Getopt_CmdAliases',
    predicate => 'has_cmd_aliases',
    coerce    => 1,
);

no Mouse;
#no Mouse::Util::TypeConstraints;

1;

=head1 NAME

MouseX::Getopt::Meta::Attribute::Getopt - Optional meta attribute for custom options

=head1 SYNOPSIS

    package MyApp;
    use Mouse;

    with 'MouseX::Getopt';

    has 'data' => (
        metaclass => 'Getopt',
        is        => 'rw',
        isa       => 'Str',

        # use --somedata as the command line flag
        # instead of the normal flag (--data)
        cmd_flag => 'somedata',

        # also allow --somedata, -s, and -d as aliases
        cmd_aliases => ['somedata', 's', 'd'],
    );

=head1 DESCRIPTION

This module is a custom attribute metaclass for providing
a command line flag to use instead of the default flag.

=head1 ATTRIBUTES

=head2 cmd_flag

Changes the default command line flag to this value.

=head2 cmd_aliases

Adds command line flag aliases, useful for short options.

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
