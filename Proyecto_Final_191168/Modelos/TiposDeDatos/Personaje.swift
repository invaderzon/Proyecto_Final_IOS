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
    let description: String
    let status: PersonajeStatus
    let species: String
    let gender: PersonajeGenero
    let origen: Origen
    let actors: [String]
    let image: String


}



/*"index": "bard",
"name": "Bard",
"hit_die": 8,
"proficiencies": []
"saving_throws": [
    {
        "index": "dex",
        "name": "DEX",
        "url": "/api/ability-scores/dex"
    },
    {
        "index": "cha",
        "name": "CHA",
        "url": "/api/ability-scores/cha"
    }
],
"starting_equipment": [
    {
        "equipment": {
            "index": "leather-armor",
            "name": "Leather Armor",
            "url": "/api/equipment/leather-armor"
        },
        "quantity": 1
    },
    {
        "equipment": {
            "index": "dagger",
            "name": "Dagger",
            "url": "/api/equipment/dagger"
        },
        "quantity": 1
    }
],*/
