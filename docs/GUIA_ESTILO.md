# Guía de estilo: revisión de la traducción de The Wolf Among Us (castellano de España)

Partimos de un parche de fans (2021) que pasó la traducción oficial latinoamericana a castellano de España.
La base suele ser aceptable. Tu trabajo es **revisar**, no retraducir: cambia una frase solo si la mejora de verdad.

## Qué corregir
- Restos de español latino: "compadre", "departamento" (→ piso), "amigo" usado como muletilla de "mate" (→ colega/tío/amigo según el caso), "manejar" (→ conducir), "carro", "agarrar" donde suene raro (→ coger/pillar), "enojado" (→ cabreado/enfadado), "¿Qué onda?", "ahorita", "lindo", "rentar", "plata" (dinero), "pararse" (ponerse de pie), "jalar", "apurarse" (→ darse prisa), "voltear", "recámara", "acá/allá" excesivos.
- Pretérito indefinido latino donde en España se usa el perfecto para algo de hoy: "¿Qué pasó aquí?" → "¿Qué ha pasado aquí?" (solo si es claramente reciente).
- Erratas, palabras duplicadas, tildes mal ("lo qué" → "lo que"), mayúscula tras punto, falta de ¿ ¡, comas mal puestas ("Te cortaste pero, ¿no…" → "Te cortaste, ¿y no…?").
- Errores de sentido respecto al inglés.
- Frases rígidas o calcadas del inglés ("Me disculpo si…", "apuesto que…", "por esa razón", "es un trivialidad").
- Tono plano: el inglés lleva acotaciones entre corchetes ([sarcastic], [dubious], [angry], [nervous]...) que NO se muestran en pantalla pero indican cómo se dice. Úsalas. Un "[dubious] Really." es "¿Ah, sí?", no "En serio.".
- Tacos: el original es muy malhablado. Mantén el nivel, en registro castizo (joder, coño, hostias, cabrón, gilipollas, me cago en..., puto/puñetero, de los cojones). No suavices ni exageres.

## Personajes y voz
- **Bigby** (Lobo): seco, cansado, directo, frases cortas.
- **Blancanieves** (Snow, "Blanca" / "señorita Nieves" cuando la llaman Miss White): correcta, formal, poco malhablada.
- **Sapo** (Toad) y otros británicos/cockney (Sapo, Dee/Dum, Holly a veces...): habla de barrio, "colega", tacos, frases vivas.
- **Leñador** (Woodsman): bruto, borracho.
- **Ichabod Crane**: pedante, estirado.
- Tratamiento: tú por defecto. Usted solo cuando hay formalidad clara (Snow con desconocidos o cargos, empleados con clientes, "Mr./Miss"…). Sé coherente dentro de la escena.

## Glosario OBLIGATORIO (traducción de Norma Editorial que usó el parche; NO cambiar)
Bigby → Lobo · Snow / Snow White → Blanca / Blancanieves · Miss White → señorita Nieves · Fabletown → Villa Fábula · Fable(s) → Fábula(s) · Mundy/Mundies → mundano(s) · The Farm → La Granja · Glamour → Glamour (con mayúscula) · Woodsman → Leñador · Toad → Sapo · Toad Jr / TJ → Sapito · Woody → Bosco · Flycatcher → Papamoscas · Bluebeard → Barbazul · Beauty → Bella · Beast → Bestia · Colin → Colin · Grendel / Gren → Grendel / Gren · Holly → Holly · Trip Trap → Trip Trap · Crane / Ichabod Crane → Crane · Faith → Faith · Lawrence → Lawrence · Tweedle Dee / Dum → Dee / Dum · Mirror → Espejo · Woodlands (edificio) → El Bosque · Sheriff → sheriff (minúscula salvo inicio de frase o cargo como título)
Si ves un nombre que no está aquí, mantén el que ya usa el parche.

## Restricciones técnicas
- **Líneas sin personaje (columna 2 vacía)** son opciones de diálogo o etiquetas de objetos en pantalla. Espacio limitado: NO las alargues; como máximo misma longitud aproximada que el texto del parche. Cámbialas solo si están mal (sentido erróneo, latinismo, errata). Mantén corchetes si los tienen ("[Subir]").
- Mantén las mismas pausas y cortes ("...", "--" del inglés → "..." en español).
- Los subtítulos deben tener una longitud parecida a la del parche (como mucho ~20 % más larga).
- Solo caracteres de Windows-1252: tildes, ñ, ü, ¿, ¡, comillas rectas "", "..." con tres puntos. Nada de emojis, rayas largas raras ni comillas tipográficas «» (sí valen comillas rectas "").
- No toques líneas que sean notas internas de desarrollo en inglés (p. ej. "can use existing animation", "*** FAKE ***"): déjalas igual.
- No traduzcas nombres de créditos (personas).

## Formato de entrada
Cada escena tiene `uniq.tsv` (UTF-8, separado por tabuladores): `uid  personaje  inglés  español_actual`.

## Formato de salida
Un fichero `cambios.txt` (UTF-8) en la carpeta de cada escena, una línea por frase cambiada:
```
uid|texto nuevo completo
```
Solo las frases que cambies. Sin cabecera, sin comentarios, sin líneas vacías. El texto no puede contener `|` ni tabuladores ni saltos de línea.

## Referencia de calibración
Las dos primeras escenas revisadas a mano (patio del edificio y piso de Sapo, episodio 1) sirvieron de referencia para el resto: ver `traduccion/F101/env_fabletownandersen_intro.tsv` y `traduccion/F101/env_andersenwoodsmanapt.tsv`, y su comparativa en `comparativa.html`.
