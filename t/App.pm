package t::App;
use Mouse;
with 'MouseX::Getopt';

has 'str' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'foo',
);

has 'int' => (
    is      => 'ro',
    isa     => 'Int',
    default => 128,
);

has 'bool' => (
    is      => 'ro',
    isa     => 'Bool',
);

has 'arrayref' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { [] },
);

has 'hashref' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { +{} },
);

has '_private_attr' => (
    is      => 'ro',
    isa     => 'Int',
    default => 1024,
);

no Mouse; __PACKAGE__->meta->make_immutable; 1;
