//
//  MainView.swift
//  ReactionGame
//
//  Created by D K on 03.12.2024.
//

import SwiftUI

struct TimeReactionGame: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isCircleVisible = false
    @State private var reactionTime: Double? = nil
    @State private var timerStart: Date? = nil
    @State private var isGameActive = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            Image("bg_1")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 10)
            
            
            if let reactionTime = reactionTime {
                VStack {
                    Text(String(format: "Reaction time: %.3f sec.", reactionTime))
                        .foregroundColor(.white)
                        .font(.system(size: 32, weight: .black))
                        .padding(.top, 100)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .onAppear {
                    StorageManager.shared.updateGameRecord(for: "REACTIONER", with: reactionTime)
                }
            }
            
            VStack {
                if isCircleVisible {
                    Spacer()
                    Image("ball_yellow")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            if let startTime = timerStart {
                                reactionTime = Date().timeIntervalSince(startTime)
                                stopGame()
                            }
                        }
                        
                    Spacer()
                }
            }
            
            VStack {
                Spacer()
                Button(action: startGame) {
                    ZStack {
                        Image(isGameActive ? "btn_orange" : "btn_blue")
                            .resizable()
                            .scaledToFit()
                            .frame(width: size().width - 100, height: 80)
                        
                        Text(isGameActive ? "Be ready..." : "Start")
                            .foregroundStyle(.white)
                            .font(.system(size: 32, weight: .black))
                    }
                }
                .disabled(isGameActive)
                .padding(.bottom, 40)
            }
            
            //MARK: - Title
            
            VStack {
                Text("REACTIONER")
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
        .onAppear {
            stopGame()
            isCircleVisible = true
        }
    }
    
    func startGame() {
        isGameActive = true
        reactionTime = nil
        isCircleVisible = false
        
        let delay = Double.random(in: 3...7)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard isGameActive else { return }
            isCircleVisible = true
            timerStart = Date()
        }
    }
    
    func stopGame() {
        isGameActive = false
        isCircleVisible = false
        timerStart = nil
    }
}


#Preview {
    TimeReactionGame()
}
