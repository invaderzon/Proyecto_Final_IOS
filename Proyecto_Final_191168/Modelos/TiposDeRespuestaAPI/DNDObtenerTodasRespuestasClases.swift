//
//  ObtenerRespuestaClase.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/20/24.
//

import Foundation

struct DNDObtenerTodasRespuestasClases: Codable {
    
    let count: Int
    //let next: String?
    //let previous: String?
    let results: [DNDClasses]
    let url: String?
}
