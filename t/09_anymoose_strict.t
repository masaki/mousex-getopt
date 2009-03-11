use Test::More;
use Test::Exception;

eval "use Any::Moose 0.05 ()";
plan skip_all => "Any::Moose 0.05 required for testing" if $@;
plan tests => 3;

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

dies_ok {
    local @ARGV = qw(--bar 1);
    MyApp->new_with_options;
} 'any_moose("X::Getopt::Strict") and NoGetopt ok';

my $strict = do {
    local @ARGV = qw(--foo 1);
    MyApp->new_with_options;
};
is $strict->foo => 1, 'any_moose("X::Getopt::Strict") and Getopt ok';
is $strict->bar => 100, 'any_moose("X::Getopt::Strict") and default value ok';
