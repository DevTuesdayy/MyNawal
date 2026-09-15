# Tarea 2: textura del catálogo

## Alcance

Fondo de estuco crema únicamente en el catálogo. Se mantienen la paleta,
las tarjetas, la navegación y el contenido cultural. No se extiende todavía
a detalle, calculadora ni postal.

La textura es una interpretación contemporánea generada por IA, no una
reproducción arqueológica ni un motivo tradicional mam.

## Asset

- Generación: herramienta integrada de imágenes, sin API externa ni clave.
- Original conservado en `~/.codex/generated_images/01a0a1d6-3f86-7212-b111-2864a37bdfb5/exec-f503b864-4b97-4091-a14d-28b200a10162.png`.
- Asset de la app: `MyNawal/MyNawal/Assets.xcassets/TexturaEstuco.imageset/estuco.jpg`.
- Optimización con `sips`: 512 × 512, JPEG calidad 85, 80 697 bytes (~79 KiB).
- Memoria de píxeles aproximada: 1 MiB a cuatro bytes por píxel; no es una medición del consumo total de la app.

### Prompt utilizado

> Use case: photorealistic-natural. Asset type: square seamless tile texture for a mobile app background. Generate a flat, front-facing scan of finely grained matte cream lime plaster / stucco, warm ivory base close to #EEE5CF. Very subtle tiny mineral pores and gentle irregular trowel variation, quiet low contrast, uniformly diffused lighting across all edges. Perfectly seamless horizontally and vertically. Entire image is only material, no objects, no perspective, no vignette, no borders, no cracks, no large stains, no symbols, no text, no patterns or carvings. This is an original contemporary material texture, not a depiction of archaeological remains. Square 1024x1024.

El generador entregó 1254 × 1254; la versión de producción está reducida a 512 × 512.

## Integración y validación

Tarea 2 terminada el 14 de septiembre de 2026.

- `FondoEstuco.swift` aplica una única imagen estática en mosaico sobre `mamBlanco`, detrás del catálogo y fuera de su contenido desplazable.
- Opacidad final: 75 %. La primera integración al 18 % resultó prácticamente imperceptible para el usuario. Se aumentó la intensidad sin cambiar el asset ni agregar filtros: el grano ahora se distingue en los espacios entre tarjetas y los textos conservan su legibilidad.
- Sin filtros, temporizadores, paralaje ni texturas adicionales por tarjeta. El fondo no recibe gestos ni se anuncia en VoiceOver.
- Con contraste aumentado se omite la imagen y permanece el fondo sólido. Esta condición se revisó en código; no se verificó activando el ajuste en el simulador.
- Compilación Debug para iPhone 17 Pro / iOS 26.5 Simulator: correcta (salida 0).
- App instalada y abierta; comparación visual de capturas antes/después: misma disposición, imágenes completas y textos legibles al tamaño predeterminado. La textura se aprecia suavemente en los espacios libres, sin uniones llamativas en el área visible.
- Capturas de validación locales: `/tmp/mynawal-catalogo-antes.png` y `/tmp/mynawal-catalogo-estuco.png` (temporales).
- Revisión posterior: compilación correcta y captura `/tmp/mynawal-catalogo-estuco-visible.png` con intensidad al 75 %, comprobada visualmente en la zona inferior del catálogo.
- No se midieron FPS ni consumo en dispositivo físico, ni se realizó una auditoría completa de texto grande/contraste. Estas comprobaciones corresponden a la validación de accesibilidad y rendimiento posterior.

No se inició la tarea 3 ni se modificaron los fondos de las otras pantallas.
