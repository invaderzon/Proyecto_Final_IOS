//
//  Endpoint.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import Foundation

/// Representa un endpoint API
@frozen enum Endpoint: String, CaseIterable, Hashable {
    /// Endpoint para obtener info de personaje
    case character
    /// Endpoint para obtener info de locacion
    case location
    /// Endpoint  para obtener info de especies
    case species
}
