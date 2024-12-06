//
//  CatchBallView.swift
//  ReactionGame
//
//  Created by D K on 03.12.2024.
//

import SwiftUI

struct CatchBallView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var balloons: [Ballooner] = []
    @State private var score = 0
    @State private var lives = 3
    @State private var gameOver = false
    @State private var timer: Timer? = nil
    
    @State private var status: Status = .pause
    @StateObject private var soundPlayer = SoundPlayer.shared
    
    
    var images: [String] = ["ball_blue", "ball_green", "ball_pink", "ball_purple", "ball_red"]

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            Image("bg_1")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 10)
            
            switch status {
            case .game:
                VStack {
                    ZStack {
                        ForEach(balloons) { balloon in
                            Image(balloon.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: balloon.size, height: balloon.size)
                                .position(x: balloon.xPosition, y: balloon.yPosition)
                                .onTapGesture {
                                    soundPlayer.playPopSound()
                                    handleBalloonTap(balloon)
                                }
                                .animation(.linear(duration: balloon.disappearanceTime), value: balloon.size)
                        }
                    }
                    .frame(height: size().height - 100)
                }
            case .stopGame:
                VStack {
                    Text("Game over!")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 32, weight: .black))
                    
                    Text("Your score: \(score)")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 32, weight: .black))
                        .padding(.top)
                    
                    Button {
                       resetGame()
                    } label: {
                        ZStack {
                            Image("btn_blue")
                                .resizable()
                                .scaledToFit()
                                .frame(width: size().width - 100, height: 80)
                            
                            Text("Try again")
                                .foregroundStyle(.white)
                                .font(.system(size: 32, weight: .black))
                        }
                    }
                    .padding()
                }
                .onAppear {
                    StorageManager.shared.updateGameRecord(for: "RUSHER", with: Double(score))
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
            
            ZStack {
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
                    Text("RUSHER")
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
                .padding(.top, 7)
                .padding(.leading)
            }
            .padding(.top, 10)
        }
    }

    func startGame() {
        spawnBalloon()
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            spawnBalloon()
        }
    }

    func spawnBalloon() {
        guard !gameOver else { return }

        balloons.removeAll()

        let disappearanceTime = Double.random(in: 0.5...3.0)

        let balloon = Ballooner(
            id: UUID(),
            color: Color.random,
            xPosition: CGFloat.random(in: 50...UIScreen.main.bounds.width - 50),
            yPosition: CGFloat.random(in: 100...UIScreen.main.bounds.height - 100),
            size: 50,
            disappearanceTime: disappearanceTime,
            image: images.randomElement() ?? "ball_blue"
        )
        balloons.append(balloon)

        withAnimation(.linear(duration: disappearanceTime)) {
            if let index = balloons.firstIndex(where: { $0.id == balloon.id }) {
                balloons[index].size = 0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + disappearanceTime) {
            if balloons.contains(where: { $0.id == balloon.id }) {
                balloons.removeAll { $0.id == balloon.id }
                lives -= 1
                checkGameOver()
            }
        }
    }

    func handleBalloonTap(_ balloon: Ballooner) {
        if let index = balloons.firstIndex(where: { $0.id == balloon.id }) {
            balloons.remove(at: index)
            score += 1
        }
    }

    func checkGameOver() {
        if lives <= 0 {
            status = .stopGame
            gameOver = true
            timer?.invalidate()
            timer = nil
        }
    }

    func resetGame() {
        
        status = .game
        balloons.removeAll()
        score = 0
        lives = 3
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            gameOver = false
            startGame()
        }
        
    }
}

struct Ballooner: Identifiable {
    let id: UUID
    var color: Color
    var xPosition: CGFloat
    var yPosition: CGFloat
    var size: CGFloat
    var disappearanceTime: Double
    var image: String
}

#Preview {
    CatchBallView()
}
