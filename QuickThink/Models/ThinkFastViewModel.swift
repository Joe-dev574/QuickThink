//
//  QuichThinkViewModel.swift
//  QuickThink
//
//  Created by Joseph DeWeese on 11/24/25.
//

import Foundation
import SwiftUI
import Combine



class ThinkFastGame: ObservableObject {
    @Published private var model: ThinkGame<String>

    @Published private(set) var hintActive: Bool = false
    @Published private(set) var gameOver: Bool = false

    @Published private(set) var gameTimeValue: Int = 60
    @AppStorage("difficultyLevelMemory") var difficultyLevelMemory: Double = 1.0

    var score: Int {
        return model.cards.filter { $0.isMatched == true }.count
    }

    private var timer: Timer?

    private var emojis: [String]

    init(emojis: [String]) {
        self.emojis = emojis
        model = ThinkFastGame.createThinkGame(emojis: emojis)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.startGameTimer()
        }
        //startNewGame()
    }

    private static func createThinkGame(emojis: [String]) -> ThinkGame<String> {
        return ThinkGame<String>(numberOfPairsOfCards: emojis.count) { index in
            emojis[index]
        }
    }

    var gameWon: Bool {
        model.cards.allSatisfy { $0.isMatched }
    }

    var cards: [ThinkGame<String>.Card] {
        model.cards
    }

    private var hintTimer: Timer?
    private var gameTimer: Timer?

    private func startHintTimer() {
        hintTimer?.invalidate()
        hintTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            self.hintActive = true
        }
    }
    

    func startGameTimer() {
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: gameTimeValue > 0 ? true : false) { _ in
            self.gameTimeValue -= 1
            if self.gameTimeValue == 0 {
                self.gameTimer?.invalidate()
                withAnimation(.smooth(duration: 0.3)) {
                    self.gameOver = true
                }
            }
        }
    }

    func stopGameTimer() {
        gameTimer?.invalidate()
        hintActive = false
        hintTimer?.invalidate()
    }

    func choose(_ card: ThinkGame<String>.Card) {
        model.choose(card)
        hintActive = false
        startHintTimer()
    }

    func startNewGame() {
        model = ThinkFastGame.createThinkGame(emojis: emojis)
        withAnimation(.smooth(duration: 0.3)) {
            self.gameOver = false
        }
        hintActive = false

        switch difficultyLevelMemory {
        case 0.0:
            gameTimeValue = 60
        case 1.0:
            gameTimeValue = 40
        case 2.0:
            gameTimeValue = 60
        default:
            gameTimeValue = 60
        }

        startGameTimer()
        startHintTimer()
    }
}
