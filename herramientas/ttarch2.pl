#!/usr/bin/perl
# Lista / extrae un .ttarch2 sin comprimir (NCTT + 3ATT)
# uso: perl ttarch2.pl archivo.ttarch2 [dir_salida]
use strict; use warnings;
my ($file, $out) = @ARGV;
open my $fh, '<:raw', $file or die "$file: $!";
local $/; my $d = <$fh>; close $fh;
my $magic = substr($d, 0, 4);
die "no NCTT: $magic\n" unless $magic eq 'NCTT';
my $base = 12;
my $m2 = substr($d, $base, 4);
die "no 3ATT/4ATT: $m2\n" unless $m2 =~ /^[34]ATT$/;
my ($ver, $nsize, $count) = unpack('VVV', substr($d, $base + 4, 12));
my $p = $base + 16;
my @e;
for (1 .. $count) {
    my ($crc, $off, $size, $unk, $nb, $no) = unpack('Q< Q< V V v v', substr($d, $p, 28));
    push @e, [$off, $size, $nb * 0x10000 + $no];
    $p += 28;
}
my $names = substr($d, $p, $nsize);
my $data = $p + $nsize;
for my $x (@e) {
    my ($off, $size, $np) = @$x;
    my $n = substr($names, $np); $n =~ s/\0.*//s;
    printf "%10d  %s\n", $size, $n;
    if ($out) {
        mkdir $out;
        open my $o, '>:raw', "$out/$n" or die "$out/$n: $!";
        print $o substr($d, $data + $off, $size); close $o;
    }
}
