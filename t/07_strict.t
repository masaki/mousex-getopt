use Test::More tests => 3;
use Test::Exception;

do {
    package MyApp;
    use Mouse;
    with 'MouseX::Getopt::Strict';

    has 'strict' => (
        metaclass => 'Getopt',
        is        => 'rw',
        isa       => 'Int',
    );

    has 'ignore' => (
        is  => 'rw',
        isa => 'Int',
    );
};

my $obj = do {
    local @ARGV = qw(--strict 1);
    MyApp->new_with_options;
};
is $obj->strict => 1, 'Getopt metaclass attribute is processing';

dies_ok {
    local @ARGV = qw(--ignore 1);
    MyApp->new_with_options;
} 'no metaclass attribute is not processing';

dies_ok {
    local @ARGV = qw(--strict 1 --ignore 1);
    MyApp->new_with_options;
} 'no metaclass attribute is not processing, too';
