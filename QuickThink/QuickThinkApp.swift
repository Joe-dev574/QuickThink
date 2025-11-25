//
//  QuickThinkApp.swift
//  QuickThink
//
//  Created by Joseph DeWeese on 11/24/25.
//

import SwiftUI

@main
struct QuickThinkApp: App {
    var body: some Scene {
        WindowGroup {
            let emojis = ["🚀", "🌕", "🚗","🦄","🌈","🌎"]
            let game = ThinkFastGame(emojis: emojis)
            QTGameView(viewModel: game)
        }
    }
}
