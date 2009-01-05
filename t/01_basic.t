use Test::Base;
use Test::Deep;
use t::App;

plan tests => 6*blocks;

filters { map { $_ => ['eval'] } qw(argv arrayref hashref) };

run {
    my $block = shift;

    local @ARGV = @{ $block->argv };
    my $app = t::App->new_with_options;
    my $name = $block->name;

    is $app->str  => $block->str,  "str ($name)";
    is $app->int  => $block->int,  "int ($name)";
    is $app->bool => $block->bool, "bool ($name)";

    cmp_deeply $app->arrayref => $block->arrayref, "arrayref ($name)";
    cmp_deeply $app->hashref  => $block->hashref,  "hashref ($name)";

    is $app->_private_attr => 1024, "_private_attr is always 1024 ($name)";
};

__END__
=== empty argv
--- argv: []
--- str: foo
--- int: 128
--- arrayref: []
--- hashref: {}

=== simple argv
--- argv: [qw(--bool --str bar --int 256)]
--- str: bar
--- int: 256
--- bool: 1
--- arrayref: []
--- hashref: {}

=== ref argv
--- argv: [qw(--arrayref foo --arrayref 128 --hashref foo=bar --hashref baz=quux)]
--- str: foo
--- int: 128
--- arrayref: [qw(foo 128)]
--- hashref: { foo => 'bar', baz => 'quux' }

=== negation on boolean
--- argv: [qw(--nobool)]
--- str: foo
--- int: 128
--- bool: 0
--- arrayref: []
--- hashref: {}
