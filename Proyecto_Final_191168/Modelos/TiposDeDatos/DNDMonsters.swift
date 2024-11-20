//
//  Monsters.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/8/24.
//

import Foundation

struct DNDMonsters: Codable {
    let id: Int
    let desc: String
    let name: String
    let size: String
    let type: String
    let subtype: String
    let group: String
    let alignment: String
    let armor_class: Int
    let hit_points: Int
    let hit_dice: String
}
