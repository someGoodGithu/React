//
//  StorageManager.swift
//  ReactionGame
//
//  Created by D K on 05.12.2024.
//

import Foundation
import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    private var realm: Realm

    private init() {
        realm = try! Realm()
    }

    func getOrCreateGameRecord(for gameName: String) -> GameRecord {
        if let existingRecord = realm.objects(GameRecord.self).filter("gameName == %@", gameName).first {
            return existingRecord
        } else {
            let newRecord = GameRecord()
            newRecord.gameName = gameName
            try! realm.write {
                realm.add(newRecord)
            }
            return newRecord
        }
    }

    // Метод для обновления рекорда
    func updateGameRecord(for gameName: String, with score: Double) {
        let gameRecord = getOrCreateGameRecord(for: gameName)
 
        if gameName == "REACTIONER" {
            if score < gameRecord.highestScore {
                try! realm.write {
                    gameRecord.highestScore = score
                    gameRecord.date = Date()  // Обновляем дату
                }
            }
        } else {
            if score > gameRecord.highestScore {
                try! realm.write {
                    gameRecord.highestScore = score
                    gameRecord.date = Date()  // Обновляем дату
                }
            }
        }
       
    }

    // Метод для получения всех рекордов
    func getAllGameRecords() -> Results<GameRecord> {
        return realm.objects(GameRecord.self).sorted(byKeyPath: "highestScore", ascending: false)
    }
}
