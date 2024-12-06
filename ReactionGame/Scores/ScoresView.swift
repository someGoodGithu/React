//
//  ScoresView.swift
//  ReactionGame
//
//  Created by D K on 05.12.2024.
//

import SwiftUI

struct ScoresView: View {
    @Environment(\.dismiss) var dismiss
    @State private var records: [GameRecord] = []
    
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
                Text("Scores")
                    .font(.system(size: 32, weight: .black))
                    .foregroundStyle(.white)
                
                if records.isEmpty {
                    Text("Oops... \nYou don't have any records yet.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .font(.system(size: 32, weight: .light))
                        .padding(.top, 150)
                } else {
                    VStack {
                        ForEach(records, id: \.self) { record in
                            Rectangle()
                                .frame(width: size().width - 40, height: 60)
                                .foregroundColor(.purple.opacity(0.5))
                                .cornerRadius(24)
                                .overlay {
                                    HStack {
                                        Text(record.gameName)
                                            .foregroundStyle(.white)
                                        
                                        Spacer()
                                        
                                        Text(formattedDate(record.date))
                                            .foregroundStyle(.white)
                                        
                                        Spacer()
                                        
                                        Text(getFormattedScore(for: record))
                                            .foregroundStyle(.white)
                                    }
                                    .padding(.horizontal)
                                }
                        }
                    }
                }
            }
            
            .padding(.top, 50)
            .scrollIndicators(.hidden)
            
            
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
        .onAppear {
        records = Array(StorageManager.shared.getAllGameRecords())
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.string(from: date)
    }
    
    func getFormattedScore(for gameRecord: GameRecord) -> String {
           if gameRecord.gameName == "REACTIONER" {
               // Округление до трех знаков после запятой
               let roundedScore = String(format: "%.3f", gameRecord.highestScore)
               return roundedScore
           } else {
               // Возвращаем целое число
               let integerScore = Int(gameRecord.highestScore)
               return "\(integerScore)"
           }
       }
}

#Preview {
    ScoresView()
}
