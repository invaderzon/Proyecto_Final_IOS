//
//  ObtenerTodasLasRespuestasPersonajes.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import Foundation

struct ObtenerTodasLasRespuestasPersonajes: Codable {
    let id: Int
    let name: String
    let description: String
    let status: PersonajeStatus
    let species: String
    let gender: PersonajeGenero
    let origen: Origen
    let actors: [String]
    let image: String
}
