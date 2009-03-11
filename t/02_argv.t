use Test::More tests => 4;
use Test::Deep;

do {
    package MyApp;
    use Mouse;
    with 'MouseX::Getopt';

    has 'foo' => (is => 'rw', isa => 'Str');
    has 'bar' => (is => 'rw', isa => 'Int');
};

my @args = qw(--foo foo --bar 1 extra args);
local @ARGV = @args;

my $app = MyApp->new_with_options;

is $app->foo => 'foo', 'foo accessor ok';
is $app->bar => 1, 'bar accessor ok';

cmp_deeply $app->ARGV => \@args, 'ARGV accessor is saved @ARGV ok';
cmp_deeply $app->extra_argv => [qw(extra args)], 'extra_argv accessor is saved extra @ARGV ok';
