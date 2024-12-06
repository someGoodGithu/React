//
//  MusicExtension.swift
//  ReactionGame
//
//  Created by D K on 05.12.2024.
//

import Foundation
import AVFoundation

class MusicPlayer: ObservableObject {
    static let shared = MusicPlayer()
    private var audioPlayer: AVAudioPlayer?

    @Published var isMusicOn: Bool {
        didSet {
            UserDefaults.standard.set(isMusicOn, forKey: "isMusicOn")
            if isMusicOn {
                playMusic()
            } else {
                stopMusic()
            }
        }
    }

    private init() {
        // Проверка, был ли это первый запуск
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.set(true, forKey: "isMusicOn") // Музыка включена по умолчанию
        }

        self.isMusicOn = UserDefaults.standard.bool(forKey: "isMusicOn")
        if isMusicOn {
            playMusic()
        }
    }

    func playMusic() {
        guard let url = Bundle.main.url(forResource: "back", withExtension: "mp3") else {
            print("Music file not found!")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Бесконечное воспроизведение
            audioPlayer?.volume = 0.2
            audioPlayer?.play()
        } catch {
            print("Error playing music: \(error.localizedDescription)")
        }
    }

    func stopMusic() {
        audioPlayer?.stop()
    }
}

class SoundPlayer: ObservableObject {
    static let shared = SoundPlayer()
    private var audioPlayer: AVAudioPlayer?

    @Published var isSoundOn: Bool {
        didSet {
            UserDefaults.standard.set(isSoundOn, forKey: "isSoundOn")
        }
    }

    init() {
        // Проверка, был ли это первый запуск
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.set(true, forKey: "isSoundOn") // Звуки включены по умолчанию
        }

        // Загружаем состояние звуков из UserDefaults
        self.isSoundOn = UserDefaults.standard.bool(forKey: "isSoundOn")
    }

    func playPopSound() {
        // Проверяем, включены ли звуки
        if isSoundOn {
            guard let url = Bundle.main.url(forResource: "pop", withExtension: "mp3") else {
                print("Sound file not found!")
                return
            }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.volume = 0.2
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
}
