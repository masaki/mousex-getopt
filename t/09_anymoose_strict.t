use Test::More tests => 4;
use Test::Exception;

SKIP: {
    eval "use Any::Moose 0.05 ()";
    skip "Any::Moose 0.05 required for testing", 4 if $@;

    BEGIN { $ENV{ANY_MOOSE} = 'Mouse' }

    do {
        package MyApp;
        use Any::Moose;
        with any_moose('X::Getopt::Strict');

        has 'foo' => (
            metaclass => 'Getopt',
            is        => 'rw',
            isa       => 'Int',
        );

        has 'bar' => (
            metaclass => 'NoGetopt',
            is        => 'rw',
            isa       => 'Int',
            default   => 100,
        );
    };

    my $app = do {
        local @ARGV = qw(--foo 1);
        MyApp->new_with_options;
    };
    isa_ok $app->meta => 'Mouse::Meta::Class';
    is $app->foo => 1, 'any_moose("X::Getopt::Strict") and Getopt ok';
    is $app->bar => 100, 'any_moose("X::Getopt::Strict") and default value ok';

    dies_ok {
        local @ARGV = qw(--bar 1);
        MyApp->new_with_options;
    } 'any_moose("X::Getopt::Strict") and NoGetopt ok';
};
