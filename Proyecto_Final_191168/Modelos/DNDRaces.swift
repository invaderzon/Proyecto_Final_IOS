//
//  Races.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/8/24.
//

import Foundation

struct DNDMRaces: Codable {
    let id:Int
    let name: String
    let desc: String
    let document: String
    let subrace_of: String
    let traits: [String]
    let url: String
}
