//
//  FallingBalls.swift
//  ReactionGame
//
//  Created by D K on 03.12.2024.
//

import SwiftUI

enum Status {
    case game
    case stopGame
    case pause
}

struct FallingBalls: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var balloons: [Balloon] = []
    @State private var maxBallons = 5
    @State private var score = 0
    @State private var lives = 2
    @State private var gameOver = true
    @State private var isWinner = false
    
    @State private var status: Status = .pause
    
    @StateObject private var soundPlayer = SoundPlayer.shared
    
    var images: [String] = ["ball_blue", "ball_green", "ball_pink", "ball_purple", "ball_red"]
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            Image("bg_3")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 10)
            
            switch status {
            case .game:
                ZStack {
                    ForEach(balloons) { balloon in
                        Image(balloon.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .position(x: balloon.xPosition, y: balloon.yPosition)
                            .onTapGesture {
                                soundPlayer.playPopSound()
                                handleBalloonTap(balloon)
                            }
                    }
                }
                .animation(.linear, value: balloons)
                .padding(.top, 170)
            case .stopGame:
                VStack {
                    if isWinner {
                        Text("Congratulations, you won! 🎉")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 32, weight: .black))
                        
                    } else {
                        Text("Game Over! \nYour Score: \(score)")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 32, weight: .black))
                            .foregroundColor(.red)
                            .shadow(color: .black, radius: 10)
                    }
                    
                    Button {
                        if isWinner {
                            maxBallons += 1
                            resetGame()
                        } else {
                            resetGame()
                        }
                        
                    } label: {
                        ZStack {
                            Image("btn_blue")
                                .resizable()
                                .scaledToFit()
                                .frame(width: size().width - 100, height: 80)
                            
                            Text(isWinner ? "Next Level" : "Try again")
                                .foregroundStyle(.white)
                                .font(.system(size: 32, weight: .black))
                        }
                    }
                    .padding()
                }
                .onAppear {
                    StorageManager.shared.updateGameRecord(for: "CATCHER", with: Double(score))
                }
            case .pause:
                Button {
                    resetGame()
                } label: {
                    ZStack {
                        Image("btn_blue")
                            .resizable()
                            .scaledToFit()
                            .frame(width: size().width - 100, height: 80)
                        
                        Text("Start")
                            .foregroundStyle(.white)
                            .font(.system(size: 32, weight: .black))
                    }
                }
            }
            
            
            //MARK: - HEARTS
            VStack {
                HStack {
                    HStack {
                        ForEach(0..<max(lives, 0), id: \.self) { index in
                            Image("heart_1")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .animation(.linear, value: lives)
             
                    Spacer()
                    Text("Score: \(score)")
                        .font(.title2)
                        .padding()
                }
                .foregroundColor(.white)
                .padding()
                .padding(.top)
                
                Spacer()
            }
            
            //MARK: - Title
            VStack {
                Text("CATCHER")
                    .foregroundStyle(.white)
                    .font(.system(size: 32, weight: .black))
                
                Spacer()
            }
            
            //MARK: - Exit
            
            VStack {
                HStack {
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .black))
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.top, 5)
            .padding(.leading)
        }
    }
    
    func startGame() {
        status = .game
        balloons = (1...maxBallons).map { _ in generateBalloon() }
        for index in balloons.indices {
            scheduleBalloonFall(at: index)
        }
    }
    
    func generateBalloon() -> Balloon {
        Balloon(
            id: UUID(),
            color: Color.random,
            xPosition: CGFloat.random(in: 50...300),
            yPosition: -50,
            image: images.randomElement() ?? "ball_red"
        )
    }
    
    func scheduleBalloonFall(at index: Int) {
        let delay = Double.random(in: 1...4)
        let fallDuration: Double = 2.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard balloons.indices.contains(index) else { return }
            
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
                guard balloons.indices.contains(index) else {
                    timer.invalidate()
                    return
                }
                
                balloons[index].yPosition += UIScreen.main.bounds.height / (fallDuration / 0.02)
                
                if balloons[index].yPosition >= UIScreen.main.bounds.height {
                    timer.invalidate()
                    checkMissedBalloon(index)
                }
            }
        }
    }
    
    func checkMissedBalloon(_ index: Int) {
        if balloons.indices.contains(index), balloons[index].yPosition >= UIScreen.main.bounds.height {
            balloons.remove(at: index)
            lives -= 1
            checkGameOver()
        }
    }
    
    func handleBalloonTap(_ balloon: Balloon) {
        if let index = balloons.firstIndex(where: { $0.id == balloon.id }) {
            balloons.remove(at: index)
            score += 1
            checkGameOver()
        }
    }
    
    func checkGameOver() {
        if lives <= 0 {
            status = .stopGame
            isWinner = false
        } else if balloons.isEmpty {
            if score >= maxBallons {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    status = .stopGame
                    isWinner = true
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    status = .stopGame
                    isWinner = false
                }
            }
          
            
        }
    }
    
    func resetGame() {
        balloons.removeAll()
        score = 0
        lives = 2
        gameOver = false
        isWinner = false
        startGame()
    }
}

struct Balloon: Identifiable, Equatable {
    let id: UUID
    var color: Color
    var xPosition: CGFloat
    var yPosition: CGFloat
    var image: String
}

extension Color {
    static var random: Color {
        Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}

#Preview {
    FallingBalls()
}
