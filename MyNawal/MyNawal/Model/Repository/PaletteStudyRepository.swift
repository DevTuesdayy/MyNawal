//
//  PaletteStudyRepository.swift
//  MyNawal1.0
//
//  Created by Emanuel on 29/08/26.
//

import Foundation

protocol PaletteStudyRepository {
    func fetchContent() -> PaletteStudyContent
}

struct MockPaletteStudyRepository: PaletteStudyRepository {
    func fetchContent() -> PaletteStudyContent {
        PaletteStudyContent(
            catalogTitle: "Catálogo de Nawales",
            catalogSubtitle: "Explora los 20 símbolos sagrados",
            catalogItems: [
                PaletteNawalItem(nombre: "Imox", esDestacado: true, nombreImagen: "Imox", significado: "Pez · Agua", descripcion: "Representa el agua, la intuición y las fuerzas profundas de la vida.", energia: "Intuición • Sensibilidad • Fluidez"),
                PaletteNawalItem(nombre: "Iq'", esDestacado: false, nombreImagen: "Iq'", significado: "Viento · Aliento", descripcion: "Representa el viento que da vida, la palabra y la comunicación.", energia: "Comunicación • Movimiento • Inspiración"),
                PaletteNawalItem(nombre: "Aq'ab'al", esDestacado: false, nombreImagen: "Aq'ab'al", significado: "Amanecer · Renovación", descripcion: "Es la primera luz, los nuevos comienzos y la oportunidad de renovar el camino.", energia: "Renovación • Esperanza • Claridad"),
                PaletteNawalItem(nombre: "K'at", esDestacado: false, nombreImagen: "K'at", significado: "Red · Vínculos", descripcion: "Representa las redes que unen, sostienen y también aquello que necesita liberarse.", energia: "Unión • Aprendizaje • Liberación"),
                PaletteNawalItem(nombre: "Kan", esDestacado: false, nombreImagen: "Kan", significado: "Movimiento · Vida", descripcion: "Expresa la energía vital, el movimiento y la sabiduría que despierta en el cuerpo.", energia: "Vitalidad • Sabiduría • Evolución"),
                PaletteNawalItem(nombre: "Kame", esDestacado: false, nombreImagen: "Kame", significado: "Transformación · Ancestros", descripcion: "Acompaña los ciclos de cambio y mantiene viva la memoria de quienes caminaron antes.", energia: "Transformación • Memoria • Trascendencia"),
                PaletteNawalItem(nombre: "Kej", esDestacado: false, nombreImagen: "Kej", significado: "Venado · Naturaleza", descripcion: "Representa el equilibrio de la naturaleza y la conexión respetuosa con los animales.", energia: "Equilibrio • Naturaleza • Fortaleza"),
                PaletteNawalItem(nombre: "Q'anil", esDestacado: false, nombreImagen: "Q'anil", significado: "Semilla · Fertilidad", descripcion: "Es la semilla que guarda el potencial de la vida, el crecimiento y la cosecha.", energia: "Fertilidad • Paciencia • Crecimiento"),
                PaletteNawalItem(nombre: "Toj", esDestacado: false, nombreImagen: "Toj", significado: "Ofrenda · Reciprocidad", descripcion: "Invita a agradecer, corresponder y restaurar el equilibrio mediante la ofrenda.", energia: "Gratitud • Reciprocidad • Armonía"),
                PaletteNawalItem(nombre: "Tz'i", esDestacado: false, nombreImagen: "Tz'i", significado: "Justicia · Autoridad", descripcion: "Representa la justicia, la palabra correcta y el equilibrio en las decisiones.", energia: "Justicia • Lealtad • Equilibrio"),
                PaletteNawalItem(nombre: "B'atz'", esDestacado: false, nombreImagen: "B'atz'", significado: "Mono · Hilo del tiempo", descripcion: "Es el hilo de la vida y del tiempo; inspira creatividad, arte y continuidad.", energia: "Creatividad • Tiempo • Continuidad"),
                PaletteNawalItem(nombre: "E", esDestacado: false, nombreImagen: "E", significado: "Camino · Destino", descripcion: "Representa el sendero de la vida, los viajes y cada paso hacia el propósito.", energia: "Camino • Experiencia • Destino"),
                PaletteNawalItem(nombre: "Aj", esDestacado: false, nombreImagen: "Aj", significado: "Hogar · Autoridad", descripcion: "Fortalece el hogar, la familia y la responsabilidad de sostener a la comunidad.", energia: "Hogar • Estabilidad • Responsabilidad"),
                PaletteNawalItem(nombre: "I'x", esDestacado: false, nombreImagen: "I'x", significado: "Madre Tierra · Jaguar", descripcion: "Conecta con la Madre Tierra, la intuición y la fuerza de los espacios sagrados.", energia: "Tierra • Intuición • Fuerza"),
                PaletteNawalItem(nombre: "Tz'ikin", esDestacado: false, nombreImagen: "Tz'ikin", significado: "Pájaro · Visión", descripcion: "Representa la visión amplia, la buena fortuna y el intercambio con el mundo.", energia: "Visión • Abundancia • Oportunidad"),
                PaletteNawalItem(nombre: "Ajmaq", esDestacado: false, nombreImagen: "Ajmaq", significado: "Perdón · Reflexión", descripcion: "Invita a reconocer los errores, pedir perdón y convertir la experiencia en sabiduría.", energia: "Perdón • Reflexión • Aprendizaje"),
                PaletteNawalItem(nombre: "No'j", esDestacado: false, nombreImagen: "No'j", significado: "Sabiduría · Pensamiento", descripcion: "Representa el conocimiento, las ideas y la sabiduría cultivada en comunidad.", energia: "Conocimiento • Ideas • Conciencia"),
                PaletteNawalItem(nombre: "Tijax", esDestacado: false, nombreImagen: "Tijax", significado: "Obsidiana · Sanación", descripcion: "Es la fuerza que corta lo negativo, protege y abre espacio para la sanación.", energia: "Sanación • Protección • Decisión"),
                PaletteNawalItem(nombre: "Kawoq", esDestacado: false, nombreImagen: "Kawoq", significado: "Relámpago · Comunidad", descripcion: "Une a la familia y la comunidad para transformar la fuerza colectiva en bienestar.", energia: "Comunidad • Cooperación • Abundancia"),
                PaletteNawalItem(nombre: "Ajpu'", esDestacado: false, nombreImagen: "Ajpu'", significado: "Luz · Sol", descripcion: "Representa la luz interior, el valor y la claridad para vencer los desafíos.", energia: "Luz • Valentía • Claridad")
            ],
            postcardTitle: "Tu postal Nawal",
            postcardSubtitle: "Una propuesta para selfie y postal compartible con la misma paleta."
        )
    }
}
