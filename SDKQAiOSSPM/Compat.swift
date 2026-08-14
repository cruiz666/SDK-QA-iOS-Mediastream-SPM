//
//  Compat.swift
//  SDKQAiOSSPM
//
//  La app mantiene el piso del SDK, iOS 12, para que QA pueda verificar en un dispositivo
//  viejo que ese piso es real. Varias APIs de apariencia son iOS 13+, así que los
//  fallbacks viven acá en vez de repartidos en `if #available` por toda la UI.
//

import UIKit

extension UIColor {

    static var qaBackground: UIColor {
        if #available(iOS 13.0, *) { return .systemBackground }
        return .white
    }

    static var qaSecondaryLabel: UIColor {
        if #available(iOS 13.0, *) { return .secondaryLabel }
        return .darkGray
    }
}

extension UIFont {

    static func qaMono(_ size: CGFloat) -> UIFont {
        if #available(iOS 13.0, *) {
            return .monospacedSystemFont(ofSize: size, weight: .regular)
        }
        return UIFont(name: "Menlo", size: size) ?? .systemFont(ofSize: size)
    }
}
