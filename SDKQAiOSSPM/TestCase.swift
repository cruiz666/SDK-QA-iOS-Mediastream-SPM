//
//  TestCase.swift
//  SDKQAiOSSPM
//
//  Catálogo de casos de prueba.
//
//  A diferencia de la suite anterior, que tenía un ViewController por caso, acá un caso es
//  un dato: título, categoría y un closure que configura el player. Agregar un caso nuevo
//  es agregar una entrada a `all` — no hay que crear archivos ni tocar la navegación.
//  Cuando un caso necesite algo que no se pueda expresar configurando el config (por
//  ejemplo manipular el player después del setup), ahí sí conviene un ViewController
//  propio.
//

import Foundation
import MediastreamPlatformSDKiOS

struct TestCase {

    enum Category: String, CaseIterable {
        case video = "Video"
    }

    let title: String
    let detail: String
    let category: Category
    /// Se ejecuta sobre un `MediastreamPlayerConfig` nuevo antes del `setup`.
    let configure: (MediastreamPlayerConfig) -> Void

    // MARK: - Contenido

    private enum Media {
        static let vod = "6a5aa6b6bc4d1eb8a5da60c5"
        static let live = "6a50036532aaea1c582f160e"

        /// Youbora se habilita en la configuración del *player*, no del media. Sin este id
        /// se resuelve el player por defecto de la cuenta, y si ese no tiene Youbora
        /// configurado la API devuelve `enabled: false` y el SDK no reporta nada.
        /// Este player reporta a la cuenta `caracoltvdev`.
        static let playerId = "6a7f45b004e80f98bf07f88a"
    }

    /// Base común a todos los casos. Un caso puede sobrescribir lo que necesite.
    private static func base(_ config: MediastreamPlayerConfig) {
        config.playerId = Media.playerId
        config.appName = "SDKQAiOSSPM"
        config.appVersion = "1.0.0"
        config.debug = true
        config.customUI = true
    }

    // MARK: - Catálogo

    static let all: [TestCase] = [

        TestCase(title: "VOD",
                 detail: "Video on demand con UI custom",
                 category: .video) { config in
            base(config)
            config.id = Media.vod
            config.type = .VOD
        },

        TestCase(title: "Live",
                 detail: "Transmisión en vivo con UI custom",
                 category: .video) { config in
            base(config)
            config.id = Media.live
            config.type = .LIVE
        },
    ]

    static func cases(in category: Category) -> [TestCase] {
        all.filter { $0.category == category }
    }
}
