//
//  Pokemon.swift
//  DailyPlanet
//
//  Created by Bo on 4/16/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct List: Codable {
    let next: String?
    let results: [Pokemon]
}
