//
//  CardView.swift
//  QuickThink
//
//  Created by Joseph DeWeese on 11/24/25.
//

import SwiftUI

struct CardView: View {
    var card: ThinkGame<String>.Card 

    private let cardBackGradient: [Color] = [
        Color.purple.opacity(0.9),
        Color.indigo.opacity(0.9)
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: 10)
                if card.isFaceUp {
                    shape.fill()
                    shape.strokeBorder(lineWidth: 1).foregroundColor(.pink)
                    Text(card.content).font(Font.system(size: fontSize(for: geometry.size)))

                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape
        
                    shape.strokeBorder(lineWidth: 1).foregroundColor(.white)
                    Image("memoryCard").resizable().aspectRatio(contentMode: .fit).padding(15)
                }
            }
            .rotation3DEffect(
                Angle(degrees: card.isFaceUp ? 0 : 180),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .animation(.smooth(duration: 0.3), value: card.isFaceUp)
        }
    }

    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}


