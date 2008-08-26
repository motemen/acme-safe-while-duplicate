use Test::Base;
use Acme::Safe::While '100';
use Test::More tests => 5;

while (1) { }
ok(1, 'simple While');

0 while 1;
ok(1, 'simple postfix While');

do { undef } while 'unko' =~ /(.)/;
ok(1, 'simple do-While');

my $cnt = 0; $cnt++ while 42 == 42;
is($cnt, 100, 'While stop exactly at 100');

while (1) {
    while (2) {
        last;
    }
}
ok(1, 'nested While');
