//
//  ObtenerTodasLasRespuestasPersonajes.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import Foundation

struct ObtenerTodasLasRespuestasPersonajes: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [Personaje]
}
