use inc::Module::Install;
name 'MouseX-Getopt';
all_from 'lib/MouseX/Getopt.pm';

requires 'Mouse' => '0.19';
requires 'Mouse::Role';
requires 'Mouse::Meta::Attribute';
requires 'Mouse::Util';
requires 'Mouse::Util::TypeConstraints';
requires 'Getopt::Long';

tests 't/*.t';
test_requires 'Test::More';
test_requires 'Test::UseAllModules';
test_requires 'Test::Deep';
test_requires 'Test::Exception';
author_tests 'xt';
use_test_base;

auto_include_deps;
WriteAll;
