use Test::More;
use Test::Exception;

eval "use Any::Moose 0.05 ()";
plan skip_all => "Any::Moose 0.05 required for testing" if $@;
plan tests => 1;

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
is $app->foo => 1, 'any_moose("X::Getopt") ok';
