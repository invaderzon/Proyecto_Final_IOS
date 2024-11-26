//
//  Extensiones.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import UIKit

extension UIView {
    /// Agrega multiples subvistas
    /// - Parameter views: Variadic views
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

extension UIDevice {
    /// Revisa si el aparato actual es en idioma de celular
    static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
}
