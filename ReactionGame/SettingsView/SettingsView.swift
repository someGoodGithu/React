//
//  Settings.swift
//  ReactionGame
//
//  Created by D K on 05.12.2024.
//

import SwiftUI
import MessageUI
import StoreKit


struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var isSoundEnable = true
    @State private var isMusicEnable = true
    
    @State private var showMail = false
    @State private var isAlertShown = false
    
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
                .blur(radius: 30)
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
                .opacity(0.4)
            
            ScrollView {
                VStack {
                    Text("Settings")
                        .font(.system(size: 32, weight: .black))
                    
                    HStack {
                        Text("USAGE")
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    .padding(.leading)
                    
                    Rectangle()
                        .frame(width: size().width - 40, height: 60)
                        .foregroundColor(.purple.opacity(0.5))
                        .cornerRadius(24)
                        .overlay {
                            HStack {
                                Text("Sounds")
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Toggle("", isOn: $soundPlayer.isSoundOn)
                            }
                            .padding(.horizontal)
                        }
                    
                    Rectangle()
                        .frame(width: size().width - 40, height: 60)
                        .foregroundColor(.purple.opacity(0.5))
                        .cornerRadius(24)
                        .overlay {
                            HStack {
                                Text("Music")
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Toggle("", isOn: $musicPlayer.isMusicOn)
                            }
                            .padding(.horizontal)
                        }
                    
                    Button {
                        
                    } label: {
                        Rectangle()
                            .frame(width: size().width - 40, height: 60)
                            .foregroundColor(.purple.opacity(0.5))
                            .cornerRadius(24)
                            .overlay {
                                HStack {
                                    Text("Reset Scores")
                                        .foregroundStyle(.white)
                                    
                                    
                                }
                                .padding(.horizontal)
                            }
                    }
                    
                    
                    HStack {
                        Text("SUPPORT")
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.top)
                    
                    Button {
                        if MFMailComposeViewController.canSendMail() {
                            showMail.toggle()
                        } else {
                            isAlertShown.toggle()
                        }
                    } label: {
                        Rectangle()
                            .frame(width: size().width - 40, height: 60)
                            .foregroundColor(.purple.opacity(0.5))
                            .cornerRadius(24)
                            .overlay {
                                HStack {
                                    Text("Feedback")
                                        .foregroundStyle(.white)
                                    
                                    
                                }
                                .padding(.horizontal)
                            }
                    }
                    .sheet(isPresented: $showMail) {
                        MailComposeView(isShowing: $showMail, subject: "Feedback", recipientEmail: "besterGamerBaller@gmail.com", textBody: "")
                    }
                    .alert("Unable to send email", isPresented: $isAlertShown) {
                        Button {
                            isAlertShown.toggle()
                        } label: {
                            Text("Ok")
                        }
                    } message: {
                        Text("Your device does not have a mail client configured. Please configure your mail or contact support on our website.")
                    }
                    
                    Button {
                        requestAppReview()
                    } label: {
                        Rectangle()
                            .frame(width: size().width - 40, height: 60)
                            .foregroundColor(.purple.opacity(0.5))
                            .cornerRadius(24)
                            .overlay {
                                HStack {
                                    Text("Rate the App 💜")
                                        .foregroundStyle(.white)
                                    
                                    
                                }
                                .padding(.horizontal)
                            }
                    }
                    
                    
                    Button {
                        openPrivacyPolicy()
                    } label: {
                        Rectangle()
                            .frame(width: size().width - 40, height: 60)
                            .foregroundColor(.purple.opacity(0.5))
                            .cornerRadius(24)
                            .overlay {
                                HStack {
                                    Text("Privacy Policy")
                                        .foregroundStyle(.white)
                                    
                                    
                                }
                                .padding(.horizontal)
                            }
                    }
                }
                .padding(.horizontal)
                .foregroundColor(.white)
            }
            .scrollIndicators(.hidden)
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
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://ReactionBallGame.homes/com.ReactionBallGame/Carmen_Bloch/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

#Preview {
    SettingsView()
}


struct MailComposeView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    let subject: String
    let recipientEmail: String
    let textBody: String
    var onComplete: ((MFMailComposeResult, Error?) -> Void)?
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.setSubject(subject)
        mailComposer.setToRecipients([recipientEmail])
        mailComposer.setMessageBody(textBody, isHTML: false)
        mailComposer.mailComposeDelegate = context.coordinator
        return mailComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposeView
        
        init(_ parent: MailComposeView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.isShowing = false
            parent.onComplete?(result, error)
        }
    }
}
