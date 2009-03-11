use Test::More tests => 2;
use Test::Exception;

SKIP: {
    eval "use Any::Moose 0.05 ()";
    skip "Any::Moose 0.05 required for testing", 2 if $@;

    BEGIN { $ENV{ANY_MOOSE} = 'Mouse' }

    do {
        package MyApp;
        use Any::Moose;
        with any_moose('X::Getopt');

        has 'foo' => (is => 'rw', isa => 'Int');
    };

    my $app = do {
        local @ARGV = qw(--foo 1);
        MyApp->new_with_options;
    };
    isa_ok $app->meta => 'Mouse::Meta::Class';
    is $app->foo => 1, 'any_moose("X::Getopt") ok';
};
