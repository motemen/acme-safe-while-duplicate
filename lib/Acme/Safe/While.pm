package Acme::Safe::While;
use strict;
use warnings;
use Filter::Util::Call;
use base qw(Class::Data::Inheritable);

__PACKAGE__->mk_classdata(default_loop_max => 1000);

our @i;

sub import {
    my $class = shift;
    my $max = shift || $class->default_loop_max;

    my $done = 0;
    my $i = 0;
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
            $data =~ s/([{;}])([^;]*?\bwhile\s*\(?)/"$1\n\$$class\::i[@{[$i]}] = 0; $2(\$$class\::i[@{[$i++]}]++ < $max) && "/gse;
            $_ = $data . $end;
            ++$done;
        }
    );
}

__PACKAGE__;
