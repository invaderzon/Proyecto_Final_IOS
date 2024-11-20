//
//  DNDEndpoint.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/13/24.
//

import Foundation

/// servicio de API primario para obtener los datos de DND
@frozen enum DNDEndpoint: String {
    /// Punto final para obtener info de la clase
    case classes // "clase"
    /// Punto final para obtener info del monstruo
    case monsters
    /// Punto final para obtener info de la raza
    case races
}
