use Test::Base;
use Test::Deep;
use t::App;

plan tests => 9;

{
    my @args = qw(--str foobarbaz --int 512 --bool extra args);
    local @ARGV = @args;
    my $app = t::App->new_with_options;

    is $app->str  => 'foobarbaz', 'str';
    is $app->int  => 512,         'int';
    is $app->bool => 1,           'bool on';

    cmp_deeply $app->arrayref => [], 'arrayref []';
    cmp_deeply $app->hashref  => {}, 'hashref {}';

    is $app->_private_attr => 1024, '_private_attr is always 1024';

    # argv
    cmp_deeply $app->ARGV       => \@args,      'ARGV accessor';
    cmp_deeply \@ARGV           => \@args,      '@ARGV unmangled';
    cmp_deeply $app->extra_argv => [qw(extra args)], 'extra_argv accessor';
}
