#!/bin/bash
# Construye los paquetes de la traducción mejorada a partir de la carpeta Pack
# del parche de Clan DLAN (variante "completa", 2021).
#
# uso: herramientas/construir.sh <Pack_del_parche_2021> <carpeta_salida>
#
# Genera:
#   <salida>/Pack        carpeta Pack completa (GOG, Epic, versiones multilenguaje)
#   <salida>/Pack_Steam  8 paquetes para Steam / Steam Deck (español en los textos "english")
#
# Requisitos: bash y perl (Git Bash en Windows, o Linux/macOS).
set -e
ORIG=$1
OUT=$2
if [ -z "$ORIG" ] || [ -z "$OUT" ] || [ ! -f "$ORIG/Fables_pc_F101_Loc_all.ttarch2" ]; then
    echo "uso: $0 <Pack_del_parche_2021> <carpeta_salida>" >&2
    exit 1
fi
H=$(cd "$(dirname "$0")" && pwd)
T=$(cd "$H/../traduccion" && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$OUT/Pack" "$OUT/Pack_Steam"

# fuente con caracteres españoles, para la variante Steam
perl "$H/ttarch2.pl" "$ORIG/Fables_pc_Spanish_all.ttarch2" "$TMP/spanish_all" > /dev/null

for A in F101 F102 F103 F104 F105 Menu Proj Boot; do
    PAQ=Fables_pc_${A}_Loc_all.ttarch2
    X=$TMP/$A/ex; N=$TMP/$A/normal; ST=$TMP/$A/steam
    mkdir -p "$X" "$N" "$ST"
    perl "$H/ttarch2.pl" "$ORIG/$PAQ" "$X" > /dev/null
    # aplica las traducciones de cada escena
    for f in "$T/$A"/*.tsv; do
        [ -f "$f" ] || continue
        b=$(basename "$f" .tsv)
        perl "$H/landb_tool.pl" apply "$X/${b}_spanish.landb" "$f" "$N/${b}_spanish.landb" > /dev/null
    done
    perl "$H/repack.pl" "$ORIG/$PAQ" "$N" "$OUT/Pack/$PAQ" > /dev/null
    # variante Steam: el texto español también ocupa el lugar del inglés
    cp "$N"/*.landb "$ST"/ 2> /dev/null || true
    for es in "$X"/*_spanish.landb; do
        b=$(basename "$es")
        src=$N/$b; [ -f "$src" ] || src=$es
        cp "$src" "$ST/$b"
        cp "$src" "$ST/${b/_spanish/_english}"
    done
    [ "$A" = Proj ] && cp "$TMP/spanish_all/CCLegendaryLegerdemain_34.font" "$ST/"
    perl "$H/repack.pl" "$ORIG/$PAQ" "$ST" "$OUT/Pack_Steam/$PAQ" > /dev/null
    echo "OK $PAQ"
done

# el resto de archivos del parche 2021 se copian sin cambios
for f in "$ORIG"/*; do
    b=$(basename "$f")
    [ -f "$OUT/Pack/$b" ] || cp -p "$f" "$OUT/Pack/"
done
echo "Listo: $OUT/Pack y $OUT/Pack_Steam"
