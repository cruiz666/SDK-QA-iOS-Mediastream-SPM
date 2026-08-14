//
//  SDKEventListeners.swift
//  SDKQAiOSSPM
//
//  Se suscribe a todos los eventos que publica el SDK y los manda al EventLog.
//
//  La lista está completa a propósito, aunque un caso concreto solo dispare unos pocos:
//  el valor para QA es ver qué llega y qué no. Un evento ausente es tan reportable como
//  uno incorrecto.
//

import Foundation
import MediastreamPlatformSDKiOS

enum SDKEventListeners {

    static func attachAll(to events: EventManager) {
        let log = EventLog.shared

        // Reproducción
        events.listenTo(eventName: "play") { log.record("play") }
        events.listenTo(eventName: "pause") { log.record("pause") }
        events.listenTo(eventName: "finish") { log.record("finish") }
        events.listenTo(eventName: "seek") { (info: Any?) in log.record("seek", info: info) }
        events.listenTo(eventName: "ready") { log.record("ready") }
        events.listenTo(eventName: "buffering") { (info: Any?) in log.record("buffering", info: info) }
        events.listenTo(eventName: "durationUpdated") { (info: Any?) in log.record("durationUpdated", info: info) }
        events.listenTo(eventName: "failedToPlayToEndTime") { (info: Any?) in log.record("failedToPlayToEndTime", info: info) }

        // `currentTimeUpdate` se emite varias veces por segundo: en el log tapa todo lo
        // demás. Se deja comentado y se activa solo si un caso lo necesita.
        // events.listenTo(eventName: "currentTimeUpdate") { (info: Any?) in log.record("currentTimeUpdate", info: info) }

        // Red
        events.listenTo(eventName: "conectionStablished") { log.record("conectionStablished") }
        events.listenTo(eventName: "conectionLost") { log.record("conectionLost") }

        // Controles
        events.listenTo(eventName: "forward") { (info: Any?) in log.record("forward", info: info) }
        events.listenTo(eventName: "backward") { (info: Any?) in log.record("backward", info: info) }
        events.listenTo(eventName: "volume") { (info: Any?) in log.record("volume", info: info) }

        // Ads
        events.listenTo(eventName: "onAdsLoaderInitialize") { log.record("onAdsLoaderInitialize") }
        events.listenTo(eventName: "onAdLoadingError") { (info: Any?) in log.record("onAdLoadingError", info: info) }
        events.listenTo(eventName: "onAdEvent") { (info: Any?) in log.record("onAdEvent", info: info) }
        events.listenTo(eventName: "onAdError") { (info: Any?) in log.record("onAdError", info: info) }
        events.listenTo(eventName: "onDAIAdEvent") { (info: Any?) in log.record("onDAIAdEvent", info: info) }

        // Fuentes
        events.listenTo(eventName: "newsourceadded") { (info: Any?) in log.record("newsourceadded", info: info) }
        events.listenTo(eventName: "localsourceadded") { (info: Any?) in log.record("localsourceadded", info: info) }
        events.listenTo(eventName: "error") { (info: Any?) in log.record("error", info: info) }

        // UI
        events.listenTo(eventName: "onFullscreen") { log.record("onFullscreen") }
        events.listenTo(eventName: "offFullscreen") { log.record("offFullscreen") }
        events.listenTo(eventName: "onDismissButton") { log.record("onDismissButton") }
        events.listenTo(eventName: "onSDKRequestDismiss") { log.record("onSDKRequestDismiss") }

        // Episodios y audio en vivo
        events.listenTo(eventName: "nextEpisodeIncoming") { (info: Any?) in log.record("nextEpisodeIncoming", info: info) }
        events.listenTo(eventName: "onLiveAudioCurrentSongChanged") { (info: Any?) in log.record("onLiveAudioCurrentSongChanged", info: info) }

        // PiP y reproducción externa
        events.listenTo(eventName: "pipStarted") { log.record("pipStarted") }
        events.listenTo(eventName: "pipStopped") { log.record("pipStopped") }
        events.listenTo(eventName: "pipRestoreFailed") { (info: Any?) in log.record("pipRestoreFailed", info: info) }
        events.listenTo(eventName: "externalPlaybackActiveChanged") { (info: Any?) in log.record("externalPlaybackActiveChanged", info: info) }
    }
}
