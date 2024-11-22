//
//  Classes.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/8/24.
//

import Foundation

struct DNDClasses: Codable {
    /*struct Proficiencies: Codable {
        let index: String
        let name: String
        let url: String
    }*/
    let index: String
    let name: String
    let hit_die: Int?
    //let proficiencies: Proficiencies?
    let class_levels: String?
    let spells: String?


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
