#!/usr/bin/perl
# Reempaqueta un .ttarch2 sin comprimir sustituyendo ficheros
# uso: perl repack.pl original.ttarch2 dir_reemplazos salida.ttarch2
use strict; use warnings;
my ($in, $rdir, $out) = @ARGV;
open my $fh, '<:raw', $in or die "$in: $!";
my $d = do { local $/; <$fh> }; close $fh;
die "no NCTT\n" unless substr($d, 0, 4) eq 'NCTT';
my $base = 12;
my ($m2, $ver, $nsize, $count) = unpack('a4 V V V', substr($d, $base, 16));
die "no 3ATT\n" unless $m2 eq '3ATT';
my $tbl = $base + 16;
my $names = substr($d, $tbl + 28 * $count, $nsize);
my $data = $tbl + 28 * $count + $nsize;
my @e;
for my $k (0 .. $count - 1) {
    my $p = $tbl + 28 * $k;
    my ($crc, $off, $size, $unk, $nb, $no) = unpack('Q< Q< V V v v', substr($d, $p, 28));
    my $n = substr($names, $nb * 0x10000 + $no); $n =~ s/\0.*//s;
    my $body = substr($d, $data + $off, $size);
    if (-f "$rdir/$n") {
        open my $r, '<:raw', "$rdir/$n" or die; $body = do { local $/; <$r> }; close $r;
        print "reemplazado: $n\n";
    }
    push @e, { k => $k, off => $off, body => $body };
}
# mantiene el orden físico original de los datos
my $blob = ''; my $cur = 0;
for my $x (sort { $a->{off} <=> $b->{off} } @e) {
    $x->{off} = $cur; $blob .= $x->{body}; $cur += length $x->{body};
}
my $head = substr($d, $base, $data - $base);
for my $x (@e) {
    substr($head, 16 + 28 * $x->{k} + 8, 12) = pack('Q< V', $x->{off}, length $x->{body});
}
my $inner = $head . $blob;
open my $o, '>:raw', $out or die "$out: $!";
print $o 'NCTT', pack('Q<', length $inner), $inner; close $o;
