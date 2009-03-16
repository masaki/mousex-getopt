use Test::More;
use Path::Class;

eval { require MouseX::ConfigFromFile };
plan $@
    ? (skip_all => 'MouseX::ConfigFromFile required for this test')
    : (tests    => 16);

do {
    package MyRole::Config;
    use Mouse::Role;
    with 'MouseX::ConfigFromFile';
    sub get_config_from_file { +{ host => 'localhost', port => 3000 } }

    package MyClass::WithConfig;
    use Mouse;
    # TODO: combine_apply
    with 'MouseX::Getopt';
    with 'MyRole::Config';
    has 'host' => (is => 'rw', isa => 'Str');
    has 'port' => (is => 'rw', isa => 'Int');

    package MyRole::Getopt;
    use Mouse::Role;
    # TODO: combine_apply
    with 'MouseX::Getopt';
    with 'MyRole::Config';

    package MyClass::With;
    use Mouse;
    with 'MyRole::Getopt';
    has 'host' => (is => 'rw', isa => 'Str');
    has 'port' => (is => 'rw', isa => 'Int');
};

do {
    package MyClass::Config;
    use Mouse;
    with 'MouseX::ConfigFromFile';
    sub get_config_from_file { +{ host => 'localhost', port => 3000 } }

    package MyClass::ExtendConfig;
    use Mouse;
    with 'MouseX::Getopt';
    extends 'MyClass::Config';
    has 'host' => (is => 'rw', isa => 'Str');
    has 'port' => (is => 'rw', isa => 'Int');

    package MyClass::Getopt;
    use Mouse;
    with 'MouseX::Getopt';
    extends 'MyClass::Config';

    package MyClass::Extend;
    use Mouse;
    extends 'MyClass::Getopt';
    has 'host' => (is => 'rw', isa => 'Str');
    has 'port' => (is => 'rw', isa => 'Int');
};

for my $suffix (qw/WithConfig With ExtendConfig Extend/) {
    my $class = "MyClass::${suffix}";
    local @ARGV = qw(--configfile /path/to/myapp.conf);
    my $app = $class->new_with_options;

    isa_ok $app->configfile => 'Path::Class::File';
    is $app->configfile => file('/path/to/myapp.conf'), 'getopt --configfile ok';
    is $app->host => 'localhost', 'get_config_from_file ok';
    is $app->port => 3000, 'get_config_from_file ok';
}
