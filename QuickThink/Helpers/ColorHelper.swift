//
//  ColorHelper.swift
//  QuickThink
//
//  Created by Joseph DeWeese on 11/24/25.
//

import Foundation
import SwiftUI


struct CDText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Bebas Neue", size: 150))
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .foregroundStyle(.yellow)
            .shadow(color: .black, radius: 2, x: 0.0, y: 1)
            .padding(70)
    }
}
