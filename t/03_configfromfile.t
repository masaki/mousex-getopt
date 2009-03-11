use Test::More;

eval "use MouseX::ConfigFromFile";
plan skip_all => 'MouseX::ConfigFromFile required for this test' if $@;
plan tests => 8;


do {
    package Foo;
    use Mouse;
    with 'MouseX::ConfigFromFile';
    with 'MouseX::Getopt';

    has 'config' => ( is => 'ro', isa => 'Str' );

    sub get_config_from_file { +{ config => 'configvalue' } }

    package Bar;
    use Mouse;
    with 'MouseX::ConfigFromFile';
    with 'MouseX::Getopt';

    has 'config' => ( is => 'ro', isa => 'Str' );
    has '+configfile' => ( default => '/path/to/bar' );

    sub get_config_from_file { +{ config => 'configvalue' } }
};

my $obj;

# Foo
$obj = do {
    local @ARGV = qw(--configfile /path/to/config);
    Foo->new_with_options;
};
is $obj->config => 'configvalue', 'set config from get_config_from_file ok';
is $obj->configfile => '/path/to/config', 'getopt --configfile ok';

$obj = do {
    local @ARGV = ();
    Foo->new_with_options;
};
is $obj->config => undef, 'do not set config ok';
is $obj->configfile => undef, 'no --configfile ok';

# Bar
$obj = do {
    local @ARGV = qw(--configfile /path/to/config);
    Bar->new_with_options;
};
is $obj->config => 'configvalue', 'set config from get_config_from_file ok';
is $obj->configfile => '/path/to/config', 'getopt --configfile ok';

$obj = do {
    local @ARGV = ();
    Bar->new_with_options;
};
is $obj->config => 'configvalue', 'set config from get_config_from_file ok';
is $obj->configfile => '/path/to/bar', 'set configfile attr default ok';
