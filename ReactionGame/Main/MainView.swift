//
//  MainView.swift
//  ReactionGame
//
//  Created by D K on 04.12.2024.
//

import SwiftUI

struct MainView: View {
    
    @State private var isFirstGameShown = false
    @State private var isSecondGameShown = false
    @State private var isThirdGameShown = false
    @State private var isFourthGameShown = false
    @State private var isFifthGameShown = false
    
    @State private var isScoresGameShown = false
    @State private var isSettingsGameShown = false
    @State private var howToPlay = false
    
    @StateObject private var musicPlayer = MusicPlayer.shared
    @StateObject private var soundPlayer = SoundPlayer.shared
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            Image("bg_2")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 10)
            
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size().width - 40, height: 200)
                    .shadow(radius: 10, y: 1)
                    .padding(.top)
                ScrollView {
                    
                    HStack {
                        Button {
                            isFirstGameShown.toggle()
                        } label: {
                            VStack {
                                
                                Image("button2")
                                    .resizable()
                                    .frame(width: 160, height: 160)
                                    .shadow(radius: 10, y: 2)
                                
                                Text("CATCHER")
                                    .font(.system(size: 12, weight: .black))
                                    .foregroundStyle(.white)
                                    .shadow(radius: 1)
                            }
                        }
                        
                        
                        Button {
                            isSecondGameShown.toggle()
                        } label: {
                            VStack {
                                Image("button3")
                                    .resizable()
                                    .frame(width: 160, height: 160)
                                    .shadow(radius: 10, y: 2)
                                
                                Text("RUSHER")
                                    .font(.system(size: 12, weight: .black))
                                    .foregroundStyle(.white)
                                    .shadow(radius: 1)
                            }
                        }
                        
                        
                    }
                    
                    HStack {
                        Button {
                            isThirdGameShown.toggle()
                        } label: {
                            VStack {
                                Image("button4")
                                    .resizable()
                                    .frame(width: 160, height: 160)
                                    .shadow(radius: 10, y: 2)
                                
                                Text("COLOROID")
                                    .font(.system(size: 12, weight: .black))
                                    .foregroundStyle(.white)
                                    .shadow(radius: 1)
                            }
                        }
                        
                        Button {
                            isFourthGameShown.toggle()
                        } label: {
                            VStack {
                                Image("button5")
                                    .resizable()
                                    .frame(width: 160, height: 160)
                                    .shadow(radius: 10, y: 2)
                                
                                Text("CLOCKER")
                                    .font(.system(size: 12, weight: .black))
                                    .foregroundStyle(.white)
                                    .shadow(radius: 1)
                            }
                        }
                        
                    }
                    Button {
                        isFifthGameShown.toggle()
                    } label: {
                        Image("btn_blue")
                            .resizable()
                            .frame(width: size().width - 80, height: 70)
                            .blur(radius: 0.5)
                            .overlay {
                                Text("TEST REACTION")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundStyle(.white)
                                    .shadow(radius: 1)
                            }
                            .padding(.top)
                    }
                    
                    Button {
                        howToPlay.toggle()
                    } label: {
                        Image("btn_blue")
                            .resizable()
                            .frame(width: size().width - 80, height: 70)
                            .blur(radius: 0.5)
                            .overlay {
                                Text("HOW TO PLAY")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundStyle(.white)
                                    .shadow(radius: 1)
                            }
                            .padding(.top)
                    }
                    
                    Button {
                        isScoresGameShown.toggle()
                    } label: {
                        Image("btn_blue")
                            .resizable()
                            .frame(width: size().width - 80, height: 70)
                            .blur(radius: 0.5)
                            .overlay {
                                Text("SCORES")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundStyle(.white)
                                    .shadow(radius: 1)
                            }
                            .padding(.top)
                            .padding(.bottom, 150)
                    }
                    
                }
                .scrollIndicators(.hidden)
            }
        }
        .overlay {
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        isSettingsGameShown.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 32))
                    }
                    .padding(.top)
                }
                
                Spacer()
            }
            .padding(.trailing)
        }
        .fullScreenCover(isPresented: $isFirstGameShown) {
            FallingBalls()
        }
        .fullScreenCover(isPresented: $isSecondGameShown) {
            CatchBallView()
        }
        .fullScreenCover(isPresented: $isThirdGameShown) {
            ColorReactionView()
        }
        .fullScreenCover(isPresented: $isFourthGameShown) {
            CircleGameView()
        }
        .fullScreenCover(isPresented: $isFifthGameShown) {
            TimeReactionGame()
        }
        .fullScreenCover(isPresented: $isScoresGameShown) {
            ScoresView()
        }
        .fullScreenCover(isPresented: $isSettingsGameShown) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $howToPlay) {
            HowToPlayView()
        }
        .onAppear {
            if musicPlayer.isMusicOn {
                musicPlayer.playMusic()
            }
        }
    }
}

#Preview {
    MainView()
}
