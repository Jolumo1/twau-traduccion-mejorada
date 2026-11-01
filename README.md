# The Wolf Among Us — Traducción mejorada al castellano de España

Revisión completa de los subtítulos y textos en español de **The Wolf Among Us** (Telltale Games, 2013), hecha frase a frase contra el guion original en inglés.

Parte del [parche de traducción mejorada de Clan DLAN](https://www.clandlan.net) (Oscar "darkpadawan" Rodríguez, 2021). Ese parche ya pasaba la traducción oficial latinoamericana a castellano de España. Esta revisión lo corrige y lo pule.

## Qué cambia

- Se han revisado **~15.500 frases distintas**: los 5 episodios, los menús, los logros, los capítulos, la Fablespedia y los créditos.
- Se han cambiado **4.822 frases**, que son **5.677 líneas** en el juego. Las que ya estaban bien no se han tocado.
- **Restos de español latino**: "compadre", "departamento", "afuera", "enojado", "manejar"…
- **Erratas y puntuación**: palabras repetidas, tildes, signos ¿ ¡.
- **Errores de sentido** respecto al inglés, y frases calcadas del inglés ("Me disculpo si…", "apuesto que…").
- **Tono de cada personaje**, guiándose por las acotaciones del guion (`[sarcastic]`, `[dubious]`, `[angry]`…), que no salen en pantalla pero indican cómo se dice cada frase.
- **Coherencia** en el trato de tú y usted, en los nombres y en los tacos, con registro castizo.
- **Opciones de diálogo**: solo se han corregido las que estaban mal (por ejemplo, "[Mirar fijamente]" pasa a "[Seguir mirando]"), sin alargarlas.

Se mantienen los nombres de la edición española del cómic *Fábulas* (Norma Editorial), como en el parche original: **Lobo** (Bigby), **Blancanieves**, **Villa Fábula** (Fabletown), **Sapo**, **Papamoscas**, **Barbazul**, **La Granja**, **Hombre Tortuoso**…

En [`docs/comparativa.html`](docs/comparativa.html) están todas las frases cambiadas, con el texto en inglés, el del parche de 2021 y el nuevo.

### Ejemplos

| Inglés | Parche 2021 | Ahora |
|---|---|---|
| *No, mate, you're thinking of lizards.* | No, compadre, esos son los lagartos. | No, colega, te confundes con los lagartos. |
| *[dubious] Really.* | En serio. | ¿Ah, sí? |
| *I'm sorry me housekeeping's not up to your standards.* | Me disculpo si mis labores de hogar no llegan a tus estándares. | Perdona si mi forma de llevar la casa no está a tu altura. |
| *In a sweater…* | Vestido… | Con un jersey… |

## Instalación

Descarga el `.zip` de la sección **Releases** y haz primero una copia de la carpeta `Pack` del juego.

### GOG, Epic y versiones multilenguaje
1. Copia la carpeta `Pack` del zip en la carpeta del juego y sobrescribe los archivos.
2. Si la versión es multilenguaje, pon el juego en español.
3. Si aun así no salen los textos en español, ejecuta `fables español.reg`.

### Steam y Steam Deck
La versión de Steam solo trae inglés, y Steam vuelve a poner el idioma en inglés cada vez que arranca el juego, así que el `.reg` no sirve.
1. Copia la carpeta `Pack` del zip en la carpeta del juego y sobrescribe los archivos.
2. Copia encima los 8 archivos de `Pack_Steam` y sobrescribe. En ellos, los textos "en inglés" contienen la traducción española, y llevan la fuente con tildes y eñes.
3. **No uses** "Verificar integridad de los archivos": Steam restauraría los archivos originales.

En la Steam Deck la carpeta del juego es `~/.local/share/Steam/steamapps/common/The Wolf Among Us/`. Copia los archivos dentro de `Pack`, no crees una carpeta `Pack` dentro de otra.

Limitación en Steam: unas pocas texturas con texto, como la carta de Sapo, siguen en inglés porque están en otros paquetes del juego.

## Estructura del repositorio

```
traduccion/<paquete>/<escena>.tsv   Textos nuevos: id_de_línea <TAB> texto
herramientas/
  construir.sh                      Genera Pack y Pack_Steam desde el parche de 2021
  ttarch2.pl                        Lista y extrae archivos .ttarch2 (sin comprimir)
  landb_tool.pl                     Vuelca (dump) o reescribe (apply) textos de un .landb
  repack.pl                         Reempaqueta un .ttarch2 sustituyendo archivos
docs/
  GUIA_ESTILO.md                    Criterios de la revisión y glosario
  comparativa.html                  Todas las frases cambiadas (inglés / 2021 / nueva)
```

El repositorio solo contiene los textos nuevos y las herramientas. Los archivos del juego están en el zip de Releases.

## Construir los paquetes

Hacen falta `bash` y `perl`. En Windows vienen con Git for Windows (Git Bash); en Linux y macOS ya están instalados.

```bash
herramientas/construir.sh "/ruta/al/parche_2021/completa/Pack" salida
```

Genera `salida/Pack` (la carpeta completa) y `salida/Pack_Steam`. Parte de la carpeta `Pack` de la variante **completa** del parche de Clan DLAN. El resultado es idéntico byte a byte al de la release.

### Detalles técnicos

- Los `.ttarch2` de esta versión del juego no están comprimidos (cabecera `NCTT` + `3ATT`). `repack.pl` conserva el orden de los archivos y solo recalcula los desplazamientos.
- Los textos están en archivos `.landb` (formato `5VSM`) con codificación Windows-1252. Cada línea tiene un identificador numérico, que se mantiene, y los bloques de texto llevan delante su longitud. `landb_tool.pl` recalcula los tamaños de los bloques contenedores y de la sección.
- Reconstruir sin cambios cualquier `.landb` o `.ttarch2` del parche da un archivo idéntico al original. Así se comprobó que las herramientas interpretan bien el formato.

## Créditos

- **Traducción mejorada original (2021)**: Oscar "darkpadawan" Rodríguez, [Clan DLAN](https://www.clandlan.net).
- **Revisión de 2026**: hecha con ayuda de IA (Claude, de Anthropic), siguiendo la guía de [`docs/GUIA_ESTILO.md`](docs/GUIA_ESTILO.md).
- *The Wolf Among Us* es propiedad de sus titulares (Telltale Games / LCG Entertainment). *Fables* es una obra de Bill Willingham. Esta es una traducción de fans sin ánimo de lucro, y para usarla hace falta tener el juego original.
