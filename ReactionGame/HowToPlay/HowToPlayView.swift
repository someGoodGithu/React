//
//  HowToPlayView.swift
//  ReactionGame
//
//  Created by D K on 05.12.2024.
//

import SwiftUI

struct HowToPlayView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            Image("bg_2")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 30)
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
                .opacity(0.4)
            
            ScrollView {
                VStack {
                    Text("Game Rules")
                        .font(.system(size: 32, weight: .black))
                    
                    Text("""
1. Catcher

Bubbles appear at the top of the screen and begin to fall. Your mission is to tap on all the bubbles before they hit the bottom. As you progress, more bubbles will appear, increasing the challenge. You have 2 lives, so stay sharp!

2. Rusher

Bubbles spawn randomly on the screen and start shrinking. Your goal is to tap on them before they disappear completely. You have 3 lives, so act quickly and don’t miss a bubble!

3. Coloroid

A word describing a color appears on the screen, and you need to tap the bubble that matches the displayed color. Time is limited, and you have only 3 lives to test your reflexes and focus.

4. Clocker

A bubble moves clockwise on the screen, accompanied by a rotating line. You must press the button precisely when the bubble and the line intersect. With every successful tap, the speed increases. You have 3 lives to prove your timing skills!

Good luck, and may your reflexes guide you to victory! 🎮
""")
                    .padding(.top)
                    .padding(.bottom, 150)
                }
                .font(.system(size: 24, weight: .regular))
                .padding(.horizontal)
                .foregroundColor(.white)
            }.scrollIndicators(.hidden)
                .padding(.top, 50)
            
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 32))
                    }
                    
                    Spacer()
                }
                Spacer()
            }
            .padding(.top)
            .padding(.leading)
        }
    }
}

#Preview {
    HowToPlayView()
}
