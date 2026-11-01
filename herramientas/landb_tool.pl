#!/usr/bin/perl
# Herramienta .landb (MSV5) de The Wolf Among Us
#   dump  archivo.landb                      -> TSV utf-8: id, hablante, texto
#   apply archivo.landb cambios.tsv salida   -> reescribe textos (TSV utf-8: id <tab> texto nuevo)
use strict; use warnings;
use Encode qw(encode decode);

my ($cmd, $file, $chg, $out) = @ARGV;
open my $fh, '<:raw', $file or die "$file: $!";
my $d = do { local $/; <$fh> }; close $fh;

my ($magic, $def, $dbg, $async, $nver) = unpack('a4 V V V V', $d);
die "no es MSV5\n" unless $magic eq '5VSM';
my $hdr = 20 + 12 * $nver;
my $defEnd = $hdr + $def;
# bloque mapa: tras dos bloques de 8 bytes; u32 tamaño + u32 numero de registros
my $mapPos = $hdr + 16;
my ($mapSize, $count) = unpack('V V', substr($d, $mapPos, 8));

# Localiza en cada registro el contenedor [C][hablante][texto][08 00 00 00 ..]
sub blk { my ($p) = @_; my ($a, $b) = unpack('V V', substr($d, $p, 8)); return ($a == $b + 8) ? $a : 0 }
my @rec;   # [id, posContenedor, posTexto]
my %seen;
for (my $i = $mapPos + 8; $i + 16 < $defEnd; $i++) {
    my ($id, undef, undef, $id2) = unpack('V V V V', substr($d, $i, 16));
    next unless $id > 0x1000 && $id == $id2 && substr($d, $i + 4, 8) !~ /\0\0\0\0/;
    # busca el contenedor en los 120 bytes siguientes
    for my $p ($i + 16 .. $i + 120) {
        my $c = unpack('V', substr($d, $p, 4));
        my $a1 = blk($p + 4) or next;
        my $a2 = blk($p + 4 + $a1) or next;
        next unless $c == 4 + $a1 + $a2 + 8 && unpack('V', substr($d, $p + 4 + $a1 + $a2, 4)) == 8;
        next if $seen{$id}++;
        push @rec, [$id, $p, $p + 4 + $a1];
        $i = $p + $c - 1;
        last;
    }
}
warn sprintf("aviso: %d registros encontrados, cabecera dice %d\n", scalar @rec, $count) if @rec != $count;

sub str_at { my ($p) = @_; my $a = unpack('V', substr($d, $p, 4)); return substr($d, $p + 8, $a - 8) }

if ($cmd eq 'dump') {
    binmode STDOUT, ':utf8';
    for my $r (@rec) {
        my ($id, $c, $t) = @$r;
        my $spk = decode('cp1252', str_at($c + 4));
        my $txt = decode('cp1252', str_at($t));
        s/\t/\\t/g, s/\n/\\n/g, s/\r/\\r/g for $spk, $txt;
        print "$id\t$spk\t$txt\n";
    }
    exit;
}

die "uso: dump|apply\n" unless $cmd eq 'apply';
my %new;
open my $ch, '<:utf8', $chg or die "$chg: $!";
while (<$ch>) {
    chomp; s/\r$//; next unless /^(\d+)\t(.*)$/;
    my ($id, $t) = ($1, $2);
    $t =~ s/\\n/\n/g; $t =~ s/\\r/\r/g; $t =~ s/\\t/\t/g;
    $new{$id} = encode('cp1252', $t, sub { die sprintf "caracter no representable U+%04X en id %s\n", $_[0], $id });
}
close $ch;
my %pos = map { $_->[0] => $_ } @rec;
for (keys %new) { die "id $_ no existe en $file\n" unless $pos{$_} }

# aplica de atrás hacia delante para no invalidar posiciones
my $delta = 0;
for my $r (sort { $b->[2] <=> $a->[2] } grep { exists $new{$_->[0]} } @rec) {
    my ($id, $c, $t) = @$r;
    my $oldA = unpack('V', substr($d, $t, 4));
    my $s = $new{$id};
    my $blk = pack('V V', length($s) + 8, length $s) . $s;
    my $dd = length($blk) - $oldA;
    substr($d, $t, $oldA) = $blk;
    substr($d, $c, 4) = pack('V', unpack('V', substr($d, $c, 4)) + $dd);
    $delta += $dd;
}
substr($d, $mapPos, 4) = pack('V', $mapSize + $delta);
substr($d, 4, 4) = pack('V', $def + $delta);
open my $o, '>:raw', $out or die "$out: $!"; print $o $d; close $o;
printf "%d textos cambiados, %+d bytes\n", scalar keys %new, $delta;
