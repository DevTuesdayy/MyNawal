# MyNawal

Aplicación iOS con SwiftUI organizada con MVVM (Model–View–ViewModel).

## Estructura

```text
MyNawal/
├── MyNawal.xcodeproj
└── MyNawal/
    ├── Assets.xcassets/
    └── src/
        ├── App/                  # Punto de entrada de la aplicación
        ├── Model/                # Datos y reglas de negocio
        │   ├── Repository/       # Acceso a datos; actualmente datos de ejemplo
        │   └── UseCase/          # Operaciones que utiliza el ViewModel
        ├── ModelView/            # ViewModels: estado y acciones de las pantallas
        └── View/
            ├── ContentView.swift # Crea y conecta las dependencias de la pantalla
            ├── PaletteStudy/     # Contenedor de pestañas, catálogo, detalle y postal
            ├── Components/       # Elementos visuales reutilizables
            ├── Theme/            # Colores compartidos
            └── Prototypes/       # Bocetos originales fuera del flujo principal
```

La carpeta `ModelView` contiene los tipos `ViewModel`, siguiendo el nombre habitual
de MVVM en Swift. Los modelos no dependen de SwiftUI. Las vistas muestran los datos
y envían acciones al ViewModel; este obtiene el contenido mediante un caso de uso
y un repositorio.

## Empezar a trabajar

1. Abre `MyNawal/MyNawal.xcodeproj` en Xcode.
2. Selecciona el esquema `MyNawal` y un simulador compatible con iOS 26.5 o superior.
3. Ejecuta con **⌘R**. La app inicia en `ContentView`, que presenta las pestañas existentes.

El proyecto usa carpetas sincronizadas de Xcode: los archivos Swift nuevos dentro
de `MyNawal/MyNawal/src` se incorporan automáticamente al target.

Para agregar una funcionalidad, coloca sus datos en `Model`, su estado y acciones
en `ModelView` y su interfaz en `View`. Los detalles de distribución, colores e
imágenes pertenecen a las vistas. Mantén el acceso a datos en `Model/Repository`.

El contenido actual viene de `MockPaletteStudyRepository`. Las acciones de cámara,
guardar y compartir siguen pendientes de implementación. El catálogo original
`CatalagoNawal` y `Detail` se conservan como prototipos; las pantallas activas son
`PaletteCatalogView` y `PaletteDetailView`.
