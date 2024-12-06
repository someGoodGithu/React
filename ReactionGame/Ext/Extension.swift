//
//  Extension.swift
//  ReactionGame
//
//  Created by D K on 03.12.2024.
//

import SwiftUI

extension View {
    func size() -> CGSize {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return window.screen.bounds.size
    }
}
