//
//  ColorReactionView.swift
//  ReactionGame
//
//  Created by D K on 03.12.2024.
//

import SwiftUI

struct ColorReactionView: View {
    
    
    @Environment(\.dismiss) var dismiss
    @State private var word: String = ""
    @State private var wordColor: Color = .black
    @State private var options: [ColorBall] = []
    @State private var correctColor: Color = .black
    @State private var score: Int = 0
    @State private var lives: Int = 3
    @State private var gameOver: Bool = false
    @State private var timer: Timer? = nil
    @State private var countdown: Int = 2
    
    @State private var status: Status = .pause

    let colors: [ColorBall] = [
        ColorBall(name: "Red", color: .red),
        ColorBall(name: "Blue", color: .blue),
        ColorBall(name: "Green", color: .green),
        ColorBall(name: "Yellow", color: .yellow),
        ColorBall(name: "Purple", color: .purple)
    ]

    @StateObject private var soundPlayer = SoundPlayer.shared
    
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
                    Text(word)
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(wordColor)
                        .padding()
                        .shadow(radius: 2, y: 1)

                    Text("Time: \(countdown)")
                        .font(.title2)
                        .foregroundColor(.white)
                        .shadow(radius: 2, y: 1)
                        .padding()
                    

                    HStack {
                        ForEach(options) { ball in
                            Circle()
                                .fill(ball.color)
                                .frame(width: 60, height: 60)
                                .onTapGesture {
                                    soundPlayer.playPopSound()
                                    handleTap(on: ball)
                                }
                                .shadow(radius: 2, y: 1)
                        }
                    }
                    .padding()
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
                    StorageManager.shared.updateGameRecord(for: "COLOROID", with: Double(score))
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
                    Text("COLOROID")
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
            
        }
    }

    func startGame() {
        generateNewRound()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if countdown > 0 {
                countdown -= 1
            } else {
                lives -= 1
                checkGameOver()
                generateNewRound()
            }
        }
    }

    func generateNewRound() {
        
        guard !gameOver else { return }
        status = .game
        countdown = 2

        let correctBall = colors.randomElement()!
        word = correctBall.name
        correctColor = correctBall.color

        wordColor = colors.randomElement()!.color

        let shuffledColors = colors.shuffled()
        options = Array(shuffledColors.prefix(4))
        if !options.contains(correctBall) {
            options.append(correctBall)
            options.shuffle()
        }
    }

    func handleTap(on ball: ColorBall) {
        if ball.color == correctColor {
            score += 1
        } else {
            lives -= 1
        }
        checkGameOver()
        generateNewRound()
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
        score = 0
        lives = 3
        status = .game
        gameOver = false
        generateNewRound()
        startGame()
    }
}

struct ColorBall: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let color: Color

    static func == (lhs: ColorBall, rhs: ColorBall) -> Bool {
        lhs.id == rhs.id
    }
}

#Preview {
    ColorReactionView()
}
