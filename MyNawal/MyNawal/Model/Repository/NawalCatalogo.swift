import Foundation

enum NawalCatalogo {
    static let items: [PaletteNawalItem] = [
        PaletteNawalItem(
            nombre: "Imox",
            esDestacado: true,
            nombreImagen: "Imox",
            informacion: NawalInformacion(
                significado: "Agua y equilibrio",
                descripcion: "Representa el agua como origen y sustento de la vida. Se vincula con la lluvia, los ríos y el mar, y con la búsqueda de equilibrio entre las ideas y las emociones. En su interpretación espiritual, invita a la meditación y a cuidar las fuentes de agua.",
                energia: "Agua • Intuición • Creatividad",
                animal: "Lagarto, cocodrilo y tiburón",
                elemento: "Tierra",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/imox/")!
            )
        ),
        PaletteNawalItem(
            nombre: "Iq'",
            esDestacado: false,
            nombreImagen: "Iq'",
            informacion: NawalInformacion(
                significado: "Viento y aliento de vida",
                descripcion: "El viento expresa el aliento que anima a los seres vivos. Se relaciona con las ideas, la inspiración y los cambios. Su glifo evoca una ventana por la que circula el aire. En su interpretación espiritual, este día se dedica a agradecer la naturaleza y la existencia.",
                energia: "Inspiración • Movimiento • Imaginación",
                animal: "Colibrí",
                elemento: "Agua",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/iq/")!
            )
        ),
        PaletteNawalItem(
            nombre: "Aq'ab'al",
            esDestacado: false,
            nombreImagen: "Aq'ab'al",
            informacion: NawalInformacion(
                significado: "Amanecer y renovación",
                descripcion: "La transición entre oscuridad y luz representa el comienzo de nuevas etapas. El amanecer y el atardecer expresan su dualidad: aun en la noche existe luz y en el día hay sombra. Se asocia con la esperanza, la transparencia en los actos y la búsqueda de nuevas oportunidades.",
                energia: "Esperanza • Claridad • Renovación",
                animal: "Guacamayo",
                elemento: "Fuego",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/akabal/")!,
                notaNombre: "Se conserva Aq'ab'al, como en la lista general de MayaTecum. El título de su ficha utiliza Ak’ab’al."
            )
        ),
        PaletteNawalItem(
            nombre: "K'at",
            esDestacado: false,
            nombreImagen: "K'at",
            informacion: NawalInformacion(
                significado: "Red y vínculos",
                descripcion: "La red puede reunir y guardar el alimento, pero también simboliza los enredos que limitan la libertad. Este nawal invita a reconocer obstáculos, resolver conflictos y recuperar lo aprendido. Se relaciona con la organización de grupos y con el fortalecimiento de los vínculos comunitarios.",
                energia: "Unión • Aprendizaje • Liberación",
                animal: "Araña",
                elemento: "Aire",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/kat/")!
            )
        ),
        PaletteNawalItem(
            nombre: "Kan",
            esDestacado: false,
            nombreImagen: "Kan",
            informacion: NawalInformacion(
                significado: "Serpiente y vitalidad",
                descripcion: "La serpiente representa el movimiento y la fuerza creadora. Kan se relaciona con el fuego interior, el desarrollo espiritual y la transformación del conocimiento en sabiduría. También expresa la búsqueda de justicia, sinceridad y equilibrio en la relación con otras personas y con la naturaleza.",
                energia: "Vitalidad • Sabiduría • Equilibrio",
                animal: "Serpiente y quetzal",
                elemento: "Tierra",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/kan/")!
            )
        ),
        PaletteNawalItem(
            nombre: "Kame",
            esDestacado: false,
            nombreImagen: "Kame",
            informacion: NawalInformacion(
                significado: "Transformación y ancestros",
                descripcion: "La muerte se presenta como parte de un ciclo de transformación y nuevo comienzo. Este día se vincula con la memoria de quienes nos precedieron y con su orientación espiritual. Es una ocasión para honrar a los difuntos, reconocer su legado y reflexionar sobre los cambios de la existencia.",
                energia: "Memoria • Serenidad • Renacimiento",
                animal: "Tecolote o búho",
                elemento: "Agua",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/keme/")!,
                notaNombre: "La lista general utiliza Kame; la ficha individual utiliza Keme. Se conserva Kame sin proponer una equivalencia en mam."
            )
        ),
        PaletteNawalItem(
            nombre: "Kej",
            esDestacado: false,
            nombreImagen: "Kej",
            informacion: NawalInformacion(
                significado: "Venado y naturaleza",
                descripcion: "El venado y sus cuatro patas evocan los sostenes de las cuatro direcciones. Kej se relaciona con los bosques, la estabilidad y el equilibrio entre las personas y la Madre Tierra. Su interpretación destaca la responsabilidad hacia la comunidad y el ejercicio de la autoridad mediante el servicio.",
                energia: "Fortaleza • Balance • Responsabilidad",
                animal: "Venado",
                elemento: "Fuego",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/kej/")!,
                notaNombre: "La lista general utiliza Kej y la ficha individual Kiej. Se conserva el nombre de la lista."
            )
        ),
        PaletteNawalItem(
            nombre: "Q'anil",
            esDestacado: false,
            nombreImagen: "Q'anil",
            informacion: NawalInformacion(
                significado: "Semilla y germinación",
                descripcion: "La semilla expresa la capacidad de la vida para surgir y renovarse. Se asocia con el maíz, los alimentos y la fertilidad de plantas, animales y personas. En su interpretación espiritual, este día permite agradecer las siembras, las cosechas y los nuevos comienzos.",
                energia: "Vida • Crecimiento • Gratitud",
                animal: "Conejo",
                elemento: "Aire",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/qanil/")!
            )
        ),
        PaletteNawalItem(
            nombre: "Toj",
            esDestacado: false,
            nombreImagen: "Toj",
            informacion: NawalInformacion(
                significado: "Ofrenda y agradecimiento",
                descripcion: "La ofrenda representa una forma de corresponder por lo recibido del Creador y de la naturaleza. Toj se relaciona con el fuego ceremonial, la reconciliación y la generosidad hacia otras personas. Su sentido invita a agradecer la vida y a reconocer la responsabilidad que acompaña lo que recibimos.",
                energia: "Reciprocidad • Gratitud • Reconciliación",
                animal: "Luciérnaga",
                elemento: "Tierra",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/toj/")!,
                notaAnimal: "La ficha también incluye fuego, tierra y hongos entre sus representaciones."
            )
        ),
        PaletteNawalItem(
            nombre: "Tz'i'",
            esDestacado: false,
            nombreImagen: "Tz'i",
            informacion: NawalInformacion(
                significado: "Perro y justicia",
                descripcion: "El perro acompaña el simbolismo de la ley y la autoridad. Tz'i' se vincula con la verdad, la fidelidad y el equilibrio entre el orden material y espiritual. Su simbolismo destaca el respeto a los demás y la responsabilidad de quienes deben aplicar la justicia en su comunidad.",
                energia: "Justicia • Fidelidad • Respeto",
                animal: "Perro y coyote",
                elemento: "Agua",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/tzi/")!
            )
        ),
        PaletteNawalItem(
            nombre: "B'atz'",
            esDestacado: false,
            nombreImagen: "B'atz'",
            informacion: NawalInformacion(
                significado: "Hilo del tiempo",
                descripcion: "El hilo enlaza el pasado con el presente y representa el transcurso de la vida. También evoca el tejido, los lazos familiares y la memoria de los pueblos. Este día se asocia con las artes, el inicio de proyectos y la continuidad de las ceremonias y enseñanzas ancestrales.",
                energia: "Continuidad • Unión • Creación",
                animal: "Mono",
                elemento: "Fuego",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/batz/")!
            )
        ),
        PaletteNawalItem(
            nombre: "E",
            esDestacado: false,
            nombreImagen: "E",
            informacion: NawalInformacion(
                significado: "Camino y destino",
                descripcion: "El camino simboliza el recorrido de la vida y las acciones que acercan a una meta. También se conoce como Be'e. Se relaciona con los viajes, el trabajo y la capacidad de orientar a otras personas mediante el ejemplo, el respeto y la experiencia compartida.",
                energia: "Camino • Acción • Orientación",
                animal: "Gato de monte",
                elemento: "Aire",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/e/")!,
                notaNombre: "La ficha incluye E en el título e identifica Be’e como nombre k’iche’. E es el rótulo conservado en la app; no se presenta como nombre mam."
            )
        ),
        PaletteNawalItem(
            nombre: "Aj",
            esDestacado: false,
            nombreImagen: "Aj",
            informacion: NawalInformacion(
                significado: "Caña y hogar",
                descripcion: "La caña y la milpa que vuelven a brotar expresan continuidad y renovación. Aj se vincula con el hogar, el sustento y la protección de la familia. Su interpretación destaca la firmeza, la honestidad y el cuidado de las palabras con las que se acompaña a las nuevas generaciones.",
                energia: "Familia • Abundancia • Firmeza",
                animal: "Armadillo",
                elemento: "Tierra",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/aj/")!
            )
        ),
        PaletteNawalItem(
            nombre: "I'x",
            esDestacado: false,
            nombreImagen: "I'x",
            informacion: NawalInformacion(
                significado: "Jaguar y Madre Tierra",
                descripcion: "El jaguar representa fuerza y astucia, mientras que la dimensión femenina del signo se relaciona con la Madre Tierra. I'x también se vincula con los altares y lugares sagrados. En su interpretación espiritual, este día invita a respetar la naturaleza, agradecer a las mujeres y cuidar a los animales y plantas.",
                energia: "Naturaleza • Fuerza • Sensibilidad",
                animal: "Jaguar",
                elemento: "Agua",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/ix-2/")!
            )
        ),
        PaletteNawalItem(
            nombre: "Tz'ikin",
            esDestacado: false,
            nombreImagen: "Tz'ikin",
            informacion: NawalInformacion(
                significado: "Ave y visión",
                descripcion: "La mirada del águila expresa una perspectiva amplia. Tz'ikin se relaciona con las aves, la comunicación espiritual y la libertad. Se asocia con la prosperidad material y espiritual, y con las peticiones por proyectos, negocios y bienestar compartido, acompañadas de sencillez y amabilidad.",
                energia: "Visión • Libertad • Prosperidad",
                animal: "Águila y cóndor",
                elemento: "Fuego",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/tzikin/")!
            )
        ),
        PaletteNawalItem(
            nombre: "Ajmaq'",
            esDestacado: false,
            nombreImagen: "Ajmaq",
            informacion: NawalInformacion(
                significado: "Perdón y conciencia",
                descripcion: "Este día invita a reconocer los errores, dar y pedir perdón, y reconstruir la armonía con otras personas. La memoria de los antepasados orienta las decisiones del presente. Su simbolismo destaca la responsabilidad ética, la prudencia y el agradecimiento a la Madre Tierra por sus beneficios.",
                energia: "Perdón • Prudencia • Memoria",
                animal: "Abeja",
                elemento: "Aire",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/ajmaq/")!
            )
        ),
        PaletteNawalItem(
            nombre: "No'j",
            esDestacado: false,
            nombreImagen: "No'j",
            informacion: NawalInformacion(
                significado: "Conocimiento y sabiduría",
                descripcion: "Representa la capacidad de convertir lo aprendido y vivido en sabiduría. Se relaciona con la memoria, la creatividad y la reflexión antes de decidir. La reunión en consejo y el intercambio de ideas ocupan un lugar central: el conocimiento adquiere sentido al contribuir al bienestar de la comunidad.",
                energia: "Pensamiento • Consejo • Sabiduría",
                animal: "Pájaro carpintero",
                elemento: "Tierra",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/noj/")!,
                notaNombre: "La fuente alterna No’j y N’oj. La app conserva No’j, como en su lista general; no es una normalización lingüística certificada."
            )
        ),
        PaletteNawalItem(
            nombre: "Tijax",
            esDestacado: false,
            nombreImagen: "Tijax",
            informacion: NawalInformacion(
                significado: "Obsidiana y claridad",
                descripcion: "El cuchillo de obsidiana simboliza la capacidad de separar, terminar y afrontar dificultades. Se presenta como un día para revisar las acciones y abandonar enemistades. Su interpretación espiritual relaciona el corte con la purificación y con la búsqueda de respuestas equilibradas ante los desafíos.",
                energia: "Claridad • Valor • Purificación",
                animal: "Tucán y pez espada",
                elemento: "Agua",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/tijax/")!
            )
        ),
        PaletteNawalItem(
            nombre: "Kawoq'",
            esDestacado: false,
            nombreImagen: "Kawoq",
            informacion: NawalInformacion(
                significado: "Lluvia y comunidad",
                descripcion: "La lluvia y el trueno se vinculan con el sustento y la abundancia familiar. Su glifo representa personas que forman familias y comunidades. Kawoq' expresa el trabajo hacia un propósito común, el cuidado colectivo y la importancia de superar el egoísmo para procurar el bienestar de todos.",
                energia: "Comunidad • Unión • Bienestar",
                animal: "Tortuga",
                elemento: "Fuego",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/kawok/")!,
                notaNombre: "Kawoq’ aparece en la lista general y en el campo k’iche’ de la ficha, cuyo título utiliza Kawok."
            )
        ),
        PaletteNawalItem(
            nombre: "Ajpu'",
            esDestacado: false,
            nombreImagen: "Ajpu'",
            informacion: NawalInformacion(
                significado: "Sol y fortaleza",
                descripcion: "La luz solar representa fuerza vital y orientación espiritual. Ajpu' se vincula con los gemelos del Pop Wuj y la superación de sus pruebas. También lo asocia con las artes y la comunicación, destacando el servicio a otras personas y la capacidad de afrontar obstáculos con buen proceder.",
                energia: "Luz • Valor • Servicio",
                animal: "Ser humano",
                elemento: "Aire",
                fuente: URL(string: "https://mayatecum.com/los-nawales-maya/ajpu/")!,
                notaAnimal: "La fuente coloca al ser humano en este campo; se muestra como representación, sin inventar un animal adicional."
            )
        ),
    ]
}
