use Test::Base;

eval { require MouseX::ConfigFromFile };
if ($@) {
    plan skip_all => 'MouseX::ConfigFromFile required for this test';
}
else {
    plan tests => 8;
}

{
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
}

{ # Foo
    local @ARGV = qw(--configfile /path/to/config);
    my $obj = Foo->new_with_options;
    is $obj->config     => 'configvalue';
    is $obj->configfile => '/path/to/config';
}
{
    local @ARGV = ();
    my $obj = Foo->new_with_options;
    is $obj->config     => undef;
    is $obj->configfile => undef;
}
{ # Bar
    local @ARGV = qw(--configfile /path/to/config);
    my $obj = Bar->new_with_options;
    is $obj->config     => 'configvalue';
    is $obj->configfile => '/path/to/config';
}
{
    local @ARGV = ();
    my $obj = Bar->new_with_options;
    is $obj->config     => 'configvalue';
    is $obj->configfile => '/path/to/bar';
}
