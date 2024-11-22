//
//  Extensions.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/21/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            self.addSubview($0)
        })
    }
}
