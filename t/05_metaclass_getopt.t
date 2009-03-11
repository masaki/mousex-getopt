use Test::More tests => 5;
use Test::Exception;

do {
    package MyApp;
    use Mouse;
    with 'MouseX::Getopt';

    has 'flag' => (
        metaclass => 'Getopt',
        is        => 'rw',
        isa       => 'Str',
        cmd_flag  => 'foo',
    );

    has 'alias' => (
        metaclass   => 'Getopt',
        is          => 'rw',
        isa         => 'Str',
        cmd_aliases => [qw(bar baz)],
    );
};

my $obj;

dies_ok {
    local @ARGV = qw(--flag flag);
    MyApp->new_with_options;
}, 'remove default flag by cmd_flag ok';
$obj = do {
    local @ARGV = qw(--foo foo);
    MyApp->new_with_options;
};
is $obj->flag => 'foo', 'replace flag by cmd_flag ok';

$obj = do {
    local @ARGV = qw(--alias foo);
    MyApp->new_with_options;
};
is $obj->alias => 'foo', 'default flag by cmd_alias ok';

$obj = do {
    local @ARGV = qw(--bar foo);
    MyApp->new_with_options;
};
is $obj->alias => 'foo', 'alias flag "bar" by cmd_alias ok';

$obj = do {
    local @ARGV = qw(--baz foo);
    MyApp->new_with_options;
};
is $obj->alias => 'foo', 'alias flag "baz" by cmd_alias ok';
