# MyNawal: dirección visual

Tarea 1 finalizada el 14 de septiembre de 2026.
Este documento define la propuesta para las siguientes tareas. No implica que el diseño ya esté implementado.

## Concepto

Una interfaz cálida y contemporánea, inspirada en materiales y referencias documentadas del patrimonio mam de Guatemala: superficies minerales claras, profundidad verde y detalles que evoquen el tejido.

La identidad de la aplicación debe reconocer tanto el patrimonio histórico como la vida comunitaria actual. Las referencias locales se identificarán por su procedencia; una pieza de Todos Santos Cuchumatán no se presentará como representación de todas las comunidades mam.

## Referencias elegidas

- **Zaculeu, Huehuetenango:** referencia histórica y de composición arquitectónica. CulturaGuate lo identifica como capital del reino mam durante el Posclásico y describe sus plazas y plataformas. Inspiración: espacios amplios y jerarquía de superficies. La textura de estuco propuesta es una interpretación de diseño, no una reproducción arqueológica certificada.
  Fuente: https://culturaguate.gob.gt/parque-arqueologico-zaculeu/
- **Textiles de Todos Santos Cuchumatán:** el Museo Spurlock documenta una camisa del siglo XX (2008.23.0002) y un huipil de 1980–1981 (2011.05.0611) como cultura Mam Maya. Sus registros incluyen algodón, bordado y brocado. Inspiración inicial: materialidad del hilo y tejido. Las imágenes detalladas no pudieron recuperarse durante esta investigación y las fichas no explican significados de motivos; no se ha seleccionado ningún motivo específico para reproducir.
  Fuentes: https://www.spurlock.illinois.edu/collections/search-collection/details.php?a=2008.23.0002
  https://www.spurlock.illinois.edu/collections/search-collection/details.php?a=2011.05.0611
- **Cultura viva:** actividades de San Pedro Necta y Tajumulco documentan la transmisión del valor de la indumentaria mam a nuevas generaciones. Orientación editorial: incorporar personas, lengua, trabajo y comunidad en el futuro contenido cultural.
  Fuentes: https://guatemala.gob.gt/conversatorio-sobre-la-indumentaria-maya-en-san-pedro-necta-promueve-la-riqueza-cultural-del-pueblo-mam/
  https://noticias.mcd.gob.gt/2026/05/13/estudiantes-de-tajumulco-promueven-el-valor-de-la-indumentaria-maya-mam/

## Paleta existente y función

Se conservan los valores de Colors.swift. Son colores de marca de MyNawal; no se les atribuye un significado tradicional mam sin documentación.

| Color | Valor | Uso principal |
| --- | --- | --- |
| mamBlanco | #EEE5CF | Fondo cálido y superficies de lectura |
| mamFondo | #03302D | Texto principal y navegación |
| mamJade | #055C52 | Acciones y selección |
| mamArena | #D6B577 | Bordes y superficies secundarias |
| mamRojo | #872B26 | Acentos puntuales |
| mamAmarillo | #E7B12D | Énfasis e indicadores sobre fondo oscuro |
| mamMorado | #6F3B74 | Acento secundario ocasional |
| mamAzul | #27495E | Acento secundario ocasional |

Crema y verdes dominarán la interfaz. Rojo y amarillo ocuparán áreas pequeñas. El amarillo no se utilizará para texto pequeño sobre crema. Se comprobará el contraste de cada combinación en la tarea de accesibilidad.

## Materiales y composición

### Fondo: estuco claro

- Grano fino, mate, de contraste bajo, sobre mamBlanco.
- Sin grietas grandes, manchas oscuras ni símbolos grabados.
- La textura debe percibirse al observar el fondo, sin competir con la lectura.
- Punto inicial de prueba: opacidad de 3–5 %, ajustable al ver el resultado real.

### Tarjetas y controles

- Superficies limpias y bordes suaves; conservar radios cercanos a los 16–20 puntos ya usados.
- Borde fino y relieve discreto. Evitar que cada tarjeta parezca un bloque de piedra pesado.
- Mantener las ilustraciones completas y sus proporciones.
- Reservar verde jade para selección y acciones; mantener tipografía nativa y jerarquía clara.

### Encabezados y separadores

- Espacios amplios y títulos legibles, conservando la tipografía redondeada actual.
- Separadores de dos o tres líneas finas que evoquen hilos. Se presentarán como recurso gráfico original de la app, sin significado tradicional atribuido.
- Los patrones de una comunidad concreta se incorporarán únicamente con referencia visual y procedencia verificadas. Su ausencia no bloquea el fondo ni la composición inicial.

## Aplicación por pantalla

- **Catálogo:** primer lugar donde probar el fondo; tarjetas claras, selección jade e imágenes protagonistas.
- **Detalle:** mismo fondo, ilustración amplia y bloques de información limpios; fuente cultural visible.
- **Calculadora:** textura en los espacios libres, campo de fecha claro y botón de alto contraste.
- **Postal:** el marco y los detalles textiles se resolverán en su tarea de diseño; mantener un área limpia para el contenido compartible.
- **Tabbar:** mantener tres pestañas y el orden Catálogo, Calcular, Postal; acabado liso.

## Rendimiento y accesibilidad

- Una textura estática pequeña y reutilizable como punto de partida, sin animación del fondo.
- No agregar generación aleatoria por fotograma, paralaje ni filtros pesados para crear el material.
- No repetir textura en cada tarjeta: concentrarla en el fondo de pantalla.
- Mantener Reducir movimiento y comprobar legibilidad con texto grande.
- Validar contraste y fluidez sobre la implementación; esta propuesta no sustituye mediciones en dispositivo.

## Alcance cultural

Los resúmenes actuales de nawales proceden de MayaTecum y se atribuyen a esa fuente. Esta dirección visual no los convierte en contenido específicamente mam. La revisión de nombres, lengua y contenido mam corresponde a la tarea 5.

No se usarán traducciones inventadas, significados no documentados ni símbolos genéricos presentados como auténticamente mam. Las fotografías o motivos culturales que se incorporen después conservarán su procedencia y se revisarán sus condiciones de uso.

## Resultado y siguiente tarea

La dirección elegida es **estuco crema, verdes actuales, superficies limpias y detalles originales de hilo**, con referencias culturales identificadas. Se mantiene la paleta y la navegación existentes.

La tarea 2 consiste en crear una textura de estuco y probarla solamente en el catálogo, comparando legibilidad y apariencia antes de extenderla a otras pantallas. No se inicia automáticamente con la finalización de este documento.
