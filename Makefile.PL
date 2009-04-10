use inc::Module::Install;
name 'MouseX-Getopt';
all_from 'lib/MouseX/Getopt.pm';

requires 'Mouse' => '0.20';
requires 'Mouse::Role';
requires 'Mouse::Meta::Attribute';
requires 'Mouse::Util::TypeConstraints';
requires 'Getopt::Long';
requires 'Class::Method::Modifiers';
requires 'Scalar::Util' => '1.14';
requires 'Carp';

recommends 'Class::Method::Modifiers::Fast';

tests 't/*.t';
test_requires 'Test::More';
test_requires 'Test::UseAllModules';
test_requires 'Test::Deep';
test_requires 'Test::Exception';
test_requires 'Path::Class';
test_requires 'Any::Moose' => '0.07';
author_tests 'xt';
use_test_base;

auto_include_deps;
WriteAll;
