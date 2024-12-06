//
//  Model.swift
//  ReactionGame
//
//  Created by D K on 05.12.2024.
//

import Foundation
import RealmSwift

class GameRecord: Object {
    @Persisted var gameName: String = ""
    @Persisted var highestScore: Double = 0
    @Persisted var date: Date = Date()
}
