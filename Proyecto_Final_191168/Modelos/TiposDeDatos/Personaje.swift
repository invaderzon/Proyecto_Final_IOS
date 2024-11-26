//
//  Classes.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/8/24.
//

import Foundation

struct Personaje: Codable {
    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: RMCharacterGender
    let origin: RMOrigin
    let location: RMSingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
