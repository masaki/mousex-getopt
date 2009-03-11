use Test::More tests => 4;
use Test::Exception;

do {
    package MyApp;
    use Mouse;
    with 'MouseX::Getopt';

    has 'getopt' => (is => 'rw', isa => 'Str');
    has 'nogetopt' => (is => 'rw', isa => 'Str', metaclass => 'NoGetopt', default => 'failed');
};

{
    my @args = qw(--getopt succeeded);
    local @ARGV = @args;

    my $app = MyApp->new_with_options;

    is $app->getopt => 'succeeded', 'getopt accessor ok';
    is $app->nogetopt => 'failed', 'NoGetopt default value ok';
}

{
    local @ARGV = qw(--nogetopt succeeded);
    dies_ok { $app->new_with_options } 'NoGetopt option is goto die ok';
}

{
    local @ARGV = qw(--getopt succeeded --nogetopt succeeded);
    dies_ok { $app->new_with_options } 'NoGetopt mixed options are goto die ok';
}
