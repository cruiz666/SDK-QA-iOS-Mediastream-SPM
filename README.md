# SDK QA iOS — Swift Package Manager

App de QA del **Mediastream Platform SDK para iOS**, consumiéndolo desde su **nueva distribución por Swift Package Manager**.

Es el equivalente de [SDK-QA-iOS-Mediastream](https://github.com/cruiz666/SDK-QA-iOS-Mediastream), que consume el SDK viejo por CocoaPods. Esta arranca con dos casos —VOD y Live— a propósito: la idea es que QA la complemente con el resto de las casuísticas.

## Correrla

```bash
open SDKQAiOSSPM.xcodeproj
```

**No hay `pod install` ni workspace.** Xcode resuelve el SDK desde GitHub al abrir el proyecto. Elegí un simulador o dispositivo y corré.

Requiere Xcode 15+ y iOS 12 o superior. El piso de iOS 12 es deliberado: acompaña el del SDK, así se puede verificar en un dispositivo viejo que ese piso es real.

## Qué trae

| Caso | Contenido |
|---|---|
| **VOD** | `6a5aa6b6bc4d1eb8a5da60c5` — tráiler de ~96 s |
| **Live** | `6a50036532aaea1c582f160e` — RTMP Live |

Ambos con `customUI = true`, y con `playerId` fijado a `6a7f45b004e80f98bf07f88a`, que es un player con **Youbora habilitado**. Sin ese id se resuelve el player por defecto de la cuenta, y si ese no tiene Youbora configurado el SDK no reporta analítica — cosa que no es evidente y cuesta un rato descubrir.

Cada caso abre una pantalla con el player arriba y el **registro de eventos del SDK** abajo, en vivo.

### El registro de eventos

La suite anterior mandaba los eventos a la consola de Xcode. Acá se ven en el dispositivo, porque quien prueba no suele tener Xcode abierto y *"el evento no llegó"* es exactamente el tipo de hallazgo que hay que poder reportar con evidencia.

El botón de compartir de la barra superior exporta el log como texto plano, listo para pegar en un ticket.

Se escuchan **todos** los eventos que publica el SDK, aunque un caso concreto dispare solo unos pocos: un evento ausente es tan reportable como uno incorrecto. La excepción es `currentTimeUpdate`, que se emite varias veces por segundo y tapa el resto; está comentado en `SDKEventListeners.swift` y se activa si hace falta.

## Agregar un caso

Un caso es un dato, no un ViewController. Se agrega una entrada a `TestCase.all` y aparece solo en la lista:

```swift
TestCase(title: "VOD con ads",
         detail: "Pre-roll de IMA",
         category: .video) { config in
    base(config)
    config.id = Media.vod
    config.type = .VOD
    config.adURL = "https://pubads.g.doubleclick.net/gampad/ads?..."
},
```

No hay que crear archivos ni tocar la navegación. Si un caso necesita algo que no se puede expresar configurando el `config` —por ejemplo manipular el player después del `setup`, o probar `reloadPlayer`— ahí sí conviene un ViewController propio.

Para una categoría nueva, agregar el `case` a `TestCase.Category` y la lista se reorganiza sola.

## Qué versión del SDK usa

Está fijada a **`5.1.0-dev.2`**, un build del canal de desarrollo. La versión que la app muestra al pie de la lista y en cada caso sale de `getVersion()`, que la lee del bundle del framework — no de una constante — así que siempre corresponde al binario que se está probando. Eso vale al reportar: el número es verificable, no de memoria.

Para cambiarla, en Xcode: **Package Dependencies → MediastreamPlatformSDKiOS-spm → Version**.

| Cuándo | Qué poner |
|---|---|
| Validar un build de desarrollo puntual | `Exact` `5.1.0-dev.N` |
| Seguir siempre el último de desarrollo | `Branch` `develop` |
| Validar un candidato a producción | `Exact` `5.2.0-rc.N` |
| Producción | `Up to Next Major` desde `5.1.0` |

Cuando 5.1.0 se publique a producción, conviene mover esta app a `Up to Next Major`.

## Documentación del SDK

Todo público, no hace falta acceso al repo privado del SDK:

- [Guía de instalación e integración](https://github.com/mediastream/MediastreamPlatformSDKiOS-spm#readme) — instalación, rangos de dependencias, canales de pre-release y tabla de compatibilidad por versión.
- [Integración de Google Cast](https://github.com/mediastream/MediastreamPlatformSDKiOS-spm/blob/master/CAST_INTEGRATION.md)

## Chromecast

No está, y no es un olvido: el SDK de Google Cast **no tiene Swift Package**. Una app que lo necesite tiene que sumar `google-cast-sdk` por CocoaPods —los dos gestores conviven en un mismo proyecto— o agregar el `.xcframework` a mano. Los casos de Cast siguen en la suite vieja. La guía de integración está [acá](https://github.com/mediastream/MediastreamPlatformSDKiOS-spm/blob/master/CAST_INTEGRATION.md).
