use Test::More;

eval "use MouseX::ConfigFromFile";
plan skip_all => 'MouseX::ConfigFromFile required for this test' if $@;
plan tests => 12;


do {
    package ConfigAndGetopt;
    use Mouse;
    with 'MouseX::ConfigFromFile';
    with 'MouseX::Getopt';

    has 'config' => ( is => 'ro', isa => 'Str' );

    sub get_config_from_file {
        my ($class, $file) = @_;
        return +{ config => ($file eq '/default') ? 'foo' : 'bar' };
    }

    package DefaultConfig;
    use Mouse;
    extends 'ConfigAndGetopt';

    has '+configfile' => ( default => '/default' );

    package ConfigOnly;
    use Mouse;
    with 'MouseX::ConfigFromFile';

    has 'config' => ( is => 'rw', isa => 'Str' );

    sub get_config_from_file { +{ config => $_[1] } }

    package GetoptOnly;
    use Mouse;
    extends 'ConfigOnly';
    with 'MouseX::Getopt';
};

my $obj;

# ConfigAndGetopt
$obj = do {
    local @ARGV = qw(--configfile /path/to/config);
    ConfigAndGetopt->new_with_options;
};
is $obj->config => 'bar', 'set config from get_config_from_file ok';
is $obj->configfile => '/path/to/config', 'getopt --configfile ok';

$obj = do {
    local @ARGV = ();
    ConfigAndGetopt->new_with_options;
};
is $obj->config => undef, 'unset config ok';
is $obj->configfile => undef, 'no --configfile ok';

# DefaultConfig (extends ConfigAndGetopt)
$obj = do {
    local @ARGV = qw(--configfile /path/to/config);
    DefaultConfig->new_with_options;
};
is $obj->config => 'bar', 'set config from get_config_from_file ok';
is $obj->configfile => '/path/to/config', 'getopt --configfile ok';

$obj = do {
    local @ARGV = ();
    DefaultConfig->new_with_options;
};
is $obj->config => 'foo', 'set config from get_config_from_file ok';
is $obj->configfile => '/default', 'set configfile attr default ok';

# GetoptOnly extends ConfigOnly
$obj = do {
    local @ARGV = qw(--configfile /path/to/config);
    GetoptOnly->new_with_options;
};
is $obj->config => '/path/to/config', 'set config from get_config_from_file ok';
is $obj->configfile => '/path/to/config', 'getopt --configfile ok';

$obj = do {
    local @ARGV = ();
    GetoptOnly->new_with_options;
};
is $obj->config => undef, 'unset config ok';
is $obj->configfile => undef, 'no --configfile ok';
