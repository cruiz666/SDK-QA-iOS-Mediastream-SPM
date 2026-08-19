//
//  AppDelegate.swift
//  SDKQAiOSSPM
//
//  Ventana clásica, sin UIScene: las escenas requieren iOS 13 y esta app acompaña el piso
//  del SDK, que es iOS 12.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Necesario para audio en segundo plano y para que PiP siga sonando.
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
        try? AVAudioSession.sharedInstance().setActive(true)

        let window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: ViewController())
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window

        // Abrir un caso directo: `--case <indice>` sobre TestCase.all.
        //
        // Sirve para verificar un caso de forma desatendida —en un simulador nuevo, o desde
        // un script— y para que un reporte de bug pueda decir como reproducirlo en un
        // comando en vez de describir toques. Mismo atajo que la app de QA de Apple TV.
        let args = ProcessInfo.processInfo.arguments
        if let i = args.firstIndex(of: "--case"),
           i + 1 < args.count,
           let index = Int(args[i + 1]),
           TestCase.all.indices.contains(index) {
            nav.pushViewController(PlayerViewController(testCase: TestCase.all[index]), animated: false)
        }

        return true
    }
}
