//
//  PersonajeStatus.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import Foundation

enum PersonajeStatus: String, Codable {
    case vivo = "Alive"
    case muerto = "Dead"
    case `unknown` = "Unknown"
    
    var text: String {
        switch self {
        case .vivo, .muerto:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}
