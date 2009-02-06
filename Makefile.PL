use inc::Module::Install;
name 'MouseX-Getopt';
all_from 'lib/MouseX/Getopt.pm';

requires 'Mouse' => '0.15';
requires 'Getopt::Long';

tests 't/*.t';
test_requires 'Test::More';
test_requires 'ok';
test_requires 'Test::Deep';
author_tests 'xt';
use_test_base;

auto_include_deps;
WriteAll;
