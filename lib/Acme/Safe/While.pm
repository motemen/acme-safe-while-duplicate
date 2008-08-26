package Acme::Safe::While;
use strict;
use warnings;
use Filter::Util::Call;

our $i;

sub import {
    my $class = shift;
    my $max = shift || 1000;

    my $done = 0;
    filter_add(
        sub {
            return 0 if $done;
            my ($data, $end) = ('', '');
            while (my $status = filter_read()) {
                return $status if $status < 0;
                if (/^__(?:END|DATA)__\r?$/) {
                    $end = $_;
                    last;
                }
                $data .= $_;
                $_ = '';
            }
            $data =~ s/(while.*?{)/\$$class\::i = 0; $1 last if \$$class\::i++ > $max;/gs;
            $_ = $data . $end;
            ++$done;
        }
    );
}

__PACKAGE__;
