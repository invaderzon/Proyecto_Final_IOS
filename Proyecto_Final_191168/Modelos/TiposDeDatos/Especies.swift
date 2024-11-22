//
//  Especies.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import Foundation

struct Especies: Codable {
    let id: String
    let name: String
    let description: String
    let planetaOrigen: Origen
}
