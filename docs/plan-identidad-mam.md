# Plan acordado

Cada tarea requiere indicación del usuario antes de iniciarse.

1. **Definir la identidad visual mam.** Buscar referencias documentadas de comunidades mam de Guatemala, elegir materiales y detalles textiles, y mostrar una propuesta conservando los colores. Completada: `identidad-visual-mam.md`.
2. **Crear la textura de fondo.** Preparar una textura ligera de piedra clara o estuco; probarla primero en el catálogo para ajustar contraste y legibilidad. Completada: `tarea-2-textura.md`.
3. **Actualizar tarjetas y encabezados.** Unificar bordes, espacios y relieve; incorporar separadores inspirados en las referencias aprobadas. Completada en el catálogo; implementación y validación abajo.
4. **Adaptar las demás pantallas.** Aplicar el estilo al detalle del nawal, calculadora y postal, manteniendo consistencia con el tabbar.
5. **Revisar el contenido cultural.** Revisión editorial y de procedencia implementada: `tarea-5-contenido-cultural.md`. Se documenta la fuente k’iche’ y sus variantes; no se certifican equivalencias mam ni se agregan traducciones.
6. **Crear la sección Cultura mam.** Incorporar contenido documentado sobre lengua, territorio, tejidos y vida comunitaria. Definir primero con el usuario cómo integrarla en la navegación.
7. **Verificar rendimiento y accesibilidad.** Optimizar texturas, revisar contraste y texto grande, y comprobar navegación y animaciones en dispositivo.

## Implementación de la tarea 3

- Tarjetas del catálogo con radio exterior de 18 puntos, imagen de 10 puntos, borde arena de 1 punto y sombra discreta (radio 2, desplazamiento vertical 2).
- Superficie crema opaca con aclarado blanco, para que la textura no interfiera con la lectura dentro de las tarjetas. Selección jade con borde arena.
- Separaciones de cuadrícula uniformes de 16 puntos, margen exterior de 24 y separación entre encabezado y cuadrícula de 24.
- Encabezado centrado, tipografía redondeada con estilos nativos escalables y semántica de encabezado para VoiceOver.
- Separador estático de tres líneas arena/rojo, original de la app. Evoca hilos, sin copiar un motivo ni atribuirle significado cultural. Oculto para accesibilidad y no interactivo.
- Imágenes en ajuste proporcional, interacción y animaciones existentes conservadas. No hay nuevas imágenes, filtros de textura ni animaciones continuas.
- Detalle, calculadora, postal y tabbar no se modifican en esta tarea.

### Validación

- Compilación Debug para iPhone 17 Pro / iOS 26.5 Simulator correcta (salida 0).
- App instalada y abierta; captura `/tmp/mynawal-tarea3-catalogo.png` revisada: encabezado y separador completos, imágenes proporcionadas, nombres visibles y bordes consistentes al tamaño de texto predeterminado.
- `git diff --check` sin errores.
- No se realizó medición de FPS ni auditoría completa de accesibilidad; se mantienen para la tarea 7.

## Implementación de la tarea 4

- Detalle, calculadora y postal reutilizan `FondoEstuco` y `SeparadorHilos`, sin nuevas texturas ni animaciones continuas.
- `SuperficieEstuco` concentra el acabado liso: radio 18, borde arena de 1 punto y sombra de radio 2. Aplicado a imagen/bloques de lectura del detalle, campo de fecha y marco de postal.
- Encabezados centrados, márgenes de 24 puntos y colores existentes. Botón de calcular jade; acciones de postal con bordes y radios consistentes. Tabbar y orden intactos.
- Detalle conserva animal, elemento, asociaciones y fuentes. La postal conserva los datos de ejemplo; ahora utiliza la imagen existente correspondiente al nombre en lugar de `nawal_01`, que no estaba disponible.
- Postal con altura determinada por su contenido, sin marco de altura fija. Se retiraron las muestras de paleta de prototipo y los puntos decorativos, sustituidos por el separador de hilos.
- No se implementa el cálculo ni guardar/compartir: ya eran elementos provisionales. Tampoco se revisan las afirmaciones culturales en esta tarea.

### Validación de la tarea 4

- Compilación Debug para iPhone 17 Pro / iOS 26.5 Simulator correcta (salida 0).
- `git diff --check` sin errores.
- Revisión visual interactiva pendiente: la herramienta de control del simulador informó que no tiene permisos. No se afirma haber recorrido estas tres pantallas.
- No se inició la tarea 5.
