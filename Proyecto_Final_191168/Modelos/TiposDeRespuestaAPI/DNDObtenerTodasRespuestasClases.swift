//
//  ObtenerRespuestaClase.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/20/24.
//

import Foundation

struct DNDObtenerTodasRespuestasClases: Codable {
    let count: Int
    let next: String? //Puede que sea null
    let previous: String? //Puede que sea null
    let results: [DNDClasses]
}
