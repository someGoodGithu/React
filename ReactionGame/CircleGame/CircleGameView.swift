//
//  CircleGameView.swift
//  ReactionGame
//
//  Created by D K on 03.12.2024.
//

import SwiftUI

struct CircleGameView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var lineAngle: Double = 0
    @State private var ballAngle: Double = 0
    @State private var score: Int = 0
    @State private var lives: Int = 3
    @State private var gameOver: Bool = false
    @State private var clockwise: Bool = true
    @State private var lineSpeed = 2
    @State private var timer: Timer?
    
    @State private var status: Status = .pause
    
    let radius: CGFloat = 150
    let ballSize: CGFloat = 50
    let collisionRadius: CGFloat = 100
    
    @StateObject private var soundPlayer = SoundPlayer.shared
    
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
                VStack {
                    ZStack {

                        LineShape(angle: lineAngle, radius: radius)
                            .stroke(Color.white, lineWidth: 4)
                            .shadow(color: .red, radius: 11)
                        
                        Image("ball_blue")
                            .resizable()
                            .frame(width: ballSize, height: ballSize)
                            .position(ballPosition())
                            .offset(y: 20)
                    }
                    .frame(height: 400)
                    
                  
                    Button {
                        soundPlayer.playPopSound()
                        checkCollision()
                        changeDirection()
                    } label: {
                        ZStack {
                            Image("btn_orange")
                                .resizable()
                                .scaledToFit()
                                .frame(width: size().width - 100, height: 80)
                            
                            Text("Catch")
                                .foregroundStyle(.white)
                                .font(.system(size: 32, weight: .black))
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
                    StorageManager.shared.updateGameRecord(for: "CLOCKER", with: Double(score))
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
            
            VStack {
                if gameOver {
                   
                } else {
                 
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
                    Text("CLOCKER")
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
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            let angleChange = lineSpeed
            lineAngle += Double(angleChange)
            ballAngle -= 1
            
            if lineAngle >= 360 { lineAngle -= 360 }
            if lineAngle < 0 { lineAngle += 360 }
            if ballAngle <= -360 { ballAngle += 360 }
        }
    }
    
    func resetGame() {
        lineSpeed = 2
        score = 0
        lives = 3
        status = .game
        gameOver = false
        lineAngle = 0
        ballAngle = 0
        startGame()
    }
    
    func checkCollision() {
        let lineX = radius * cos(lineAngle.toRadians())
        let lineY = radius * sin(lineAngle.toRadians())
        let ballX = radius * cos(ballAngle.toRadians())
        let ballY = radius * sin(ballAngle.toRadians())
        
        let collisionTolerance: CGFloat = 1.5
        
        let distance = sqrt(pow(lineX - ballX, 2) + pow(lineY - ballY, 2))
        print(distance)
        if distance <= (ballSize / 2 + collisionRadius) * collisionTolerance * 1 {
            score += 1
        } else {
            lives -= 1
            if lives <= 0 {
                status = .stopGame
                gameOver = true
            }
        }
    }
    
    func changeDirection() {
        if score == 1 {
            lineSpeed += 1
        }
        
        if score == 3 {
            lineSpeed += 1
        }
        
        if score == 5 {
            lineSpeed += 1
        }
        
        if score == 10 {
            lineSpeed += 1
        }
        
        if score == 15 {
            lineSpeed += 1
        }
        
        if score == 20 {
            lineSpeed += 1
        }
        
        if score == 25 {
            lineSpeed += 1
        }
    }
    
    func ballPosition() -> CGPoint {
        let x = radius * cos(ballAngle.toRadians())
        let y = radius * sin(ballAngle.toRadians())
        return CGPoint(x: radius + x + ballSize / 2, y: radius - y + ballSize / 2)
    }
}

struct LineShape: Shape {
    let angle: Double
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let endX = center.x + radius * cos(angle.toRadians())
        let endY = center.y + radius * sin(angle.toRadians())
        path.move(to: center)
        path.addLine(to: CGPoint(x: endX, y: endY))
        return path
    }
}

extension Double {
    func toRadians() -> CGFloat {
        return CGFloat(self * .pi / 180)
    }
}


#Preview {
    CircleGameView()
}
