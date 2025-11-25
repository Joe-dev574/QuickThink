//
//  ContentView.swift
//  QuickThink
//
//  Created by Joseph DeWeese on 11/24/25.
//

import SwiftUI

struct QTGameView: View {
    @ObservedObject var viewModel: ThinkFastGame
    @AppStorage("difficultyLevelMemory") var difficultyLevelMemory: Double = 1.0
    @AppStorage("countInterstitial") var countInterstitial: Int = 0
    //MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    var tryGame: Bool = false
    @State private var areButtonsDisabled = false
    @State var selectedIndex = -1
    @State private var showOpen = false
    /// CountDown Model
    @ObservedObject var timerModel = CountDownModel()
    @State private var anim = false
    @State private var anim2 = false

    var body: some View {
        //MARK: MAIN BODY
        ZStack {
            //Background Image
            Image("bg2")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)

            ///Ready CountDown Timer
            Text("Get Ready!")
                .modifier(CDText())
                .scaleEffect(!anim2 ? 1 : 0)  // Shrinking effect
                .opacity(!anim2 ? 1 : 0)  // Fading out when timer reaches 0
                .animation(.easeInOut(duration: 8.0), value: anim)
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        withAnimation {
                            anim2 = true
                        }
                    }
                })
            //MARK: COUNTDOWN TIMER
            Text(timerModel.timerValue)
                .modifier(CDText())
                .scaleEffect(anim ? 1 : 0)  // Shrinking effect
                .opacity(anim ? 1 : 0)  // Fading out when timer reaches 0
                .animation(.easeInOut(duration: 0.5), value: anim)
                .onChange(of: timerModel.selectedTime) {
                    oldValue,
                    newValue in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        anim = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        anim = false
                    }
                }
            VStack {
                //MARK: BUTTON
                HStack {
                    Button(
                        action: {
                            presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            HStack(spacing: 5) {
                                Image(systemName: "chevron.backward")
                                    .font(.system(size: 30))
                                Text("Back")
                                    .font(.custom("Bebas Neue", size: 30))
                                    .multilineTextAlignment(.center)
                            }
                        }
                    )
                    .foregroundColor(.yellow)
                    Spacer()
                    Text("Think Fast")
                        .font(.custom("Bebas Neue", size: 35))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .foregroundColor(.yellow)
                    Spacer()
                    VStack {
                        Text(
                            "Score: \(viewModel.gameWon ? "\(viewModel.score + Int(viewModel.gameTimeValue / 5))" : "\(viewModel.score)")"
                        )
                        .font(Font.custom("Bebas Neue", size: 20))
                        .foregroundColor(.yellow)
                    }
                }
                .padding(.horizontal, 20)
                ZStack {
                    Text(
                        "\(viewModel.gameTimeValue.asTimesMinute):\(viewModel.gameTimeValue.asTimesSecond)"
                    )
                    .font(.custom("Bebas Neue", size: 20))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .foregroundColor(.yellow)

                    Text(viewModel.hintActive ? "Hint: Tap a card" : "")
                        .font(.custom("Bebas Neue", size: 20))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .foregroundColor(.orange)
                        .offset(y: 25)
                }
                Spacer()
                Spacer()
                if viewModel.gameWon {
                    VStack {
                        Image("Games2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)

                        Text("Congratulations")
                            .font(Font.custom("Bebas Neue", size: 30))
                            .foregroundColor(.blue)
                            .lineLimit(1)
                            .minimumScaleFactor(0.05)
                        Text("You Win")
                            .font(Font.custom("Bebas Neue", size: 40))
                            .foregroundColor(.white)

                        if viewModel.gameTimeValue > 0 {
                            HStack {
                                Text("Bonus")
                                    .font(Font.custom("Bebas Neue", size: 30))
                                    .foregroundColor(.yellow)
                                    .minimumScaleFactor(0.1)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                                Text(
                                    " + \(Int(viewModel.gameTimeValue / 5)) Point"
                                )
                                .font(Font.custom("Bebas Neue", size: 30))
                                .foregroundColor(.yellow)
                                .minimumScaleFactor(0.1)
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                            }
                        }
                    }
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 20).foregroundColor(
                            .gray
                        ).shadow(
                            color: .black.opacity(0.5),
                            radius: 10,
                            x: 0.0,
                            y: 0.0
                        )
                    )

                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).stroke(
                                    lineWidth: 2
                                ).frame(
                                    width: 100,
                                    height: 40,
                                    alignment: .center
                                ).foregroundColor(.blue)
                                RoundedRectangle(cornerRadius: 10).frame(
                                    width: 100,
                                    height: 40,
                                    alignment: .center
                                ).foregroundColor(.black.opacity(0.3))
                                Text("Menu")
                                    .font(Font.custom("Bebas Neue", size: 25))
                                    .foregroundColor(.white)
                                    .shadow(
                                        color: .black.opacity(0.8),
                                        radius: 1,
                                        x: 0,
                                        y: 0
                                    )
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                        }
                        Button(action: {
                            viewModel.startNewGame()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).stroke(
                                    lineWidth: 2
                                ).frame(
                                    width: 100,
                                    height: 40,
                                    alignment: .center
                                ).foregroundColor(.blue)
                                RoundedRectangle(cornerRadius: 10).frame(
                                    width: 100,
                                    height: 40,
                                    alignment: .center
                                ).foregroundColor(.black.opacity(0.3))
                                Text("Again")
                                    .font(Font.custom("Bebas Neue", size: 25))
                                    .foregroundColor(.white)
                                    .shadow(
                                        color: .black.opacity(0.8),
                                        radius: 1,
                                        x: 0,
                                        y: 0
                                    )
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                        }
                    }
                    Spacer()

                } else if viewModel.gameOver {
                    //MARK:  MENU - PLAY AGAIN
                    VStack {
                        Image("Games2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)

                        Text("Play Again!")
                            .font(Font.custom("Bebas Neue", size: 30))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.05)
                        Text("Game Over")
                            .font(Font.custom("Bebas Neue", size: 40))
                            .foregroundColor(.white)
                    }
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 20).foregroundColor(
                            .orange
                        ).shadow(
                            color: .black.opacity(0.5),
                            radius: 10,
                            x: 0.0,
                            y: 0.0
                        )
                    )
                    .padding(10)
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).stroke(
                                    lineWidth: 2
                                ).frame(
                                    width: 100,
                                    height: 40,
                                    alignment: .center
                                ).foregroundColor(.blue)
                                RoundedRectangle(cornerRadius: 10).frame(
                                    width: 100,
                                    height: 40,
                                    alignment: .center
                                ).foregroundColor(.black.opacity(0.3))
                                Text("Menu")
                                    .font(Font.custom("Bebas Neue", size: 25))
                                    .foregroundColor(.white)
                                    .shadow(
                                        color: .black.opacity(0.8),
                                        radius: 1,
                                        x: 0,
                                        y: 0
                                    )
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                        }
                        Button(action: {
                            viewModel.startNewGame()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).stroke(
                                    lineWidth: 2
                                ).frame(
                                    width: 100,
                                    height: 40,
                                    alignment: .center
                                ).foregroundColor(.blue)
                                RoundedRectangle(cornerRadius: 10).frame(
                                    width: 100,
                                    height: 40,
                                    alignment: .center
                                ).foregroundColor(.black.opacity(0.3))
                                Text("Again")
                                    .font(Font.custom("Bebas Neue", size: 25))
                                    .foregroundColor(.white)
                                    .shadow(
                                        color: .black.opacity(0.8),
                                        radius: 1,
                                        x: 0,
                                        y: 0
                                    )
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                        }
                    }

                    Spacer()

                } else {
                    LazyVGrid(
                        columns: [GridItem](
                            repeating: GridItem(.flexible()),
                            count: difficultyLevelMemory == 2 ? 4 : 3
                        )
                    ) {
                        ForEach(viewModel.cards) { card in
                            CardView(card: card)
                                .gesture(
                                    TapGesture()
                                        .onEnded { _ in

                                            if !viewModel.gameOver
                                                && selectedIndex != viewModel
                                                    .cards.firstIndex(where: {
                                                        $0.id == card.id
                                                    }) ?? -1
                                            {
                                                viewModel.choose(card)
                                            }
                                            selectedIndex =
                                                viewModel.cards.firstIndex(
                                                    where: { $0.id == card.id })
                                                ?? -1
                                        }
                                )
                                .disabled(areButtonsDisabled)
                                .scaledToFit()
                        }
                    }
                    .padding()
                    .opacity(showOpen ? 1 : 0)

                    Spacer()
                        .onAppear(perform: {
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 4.2
                            ) {
                                withAnimation(.smooth) {
                                    showOpen = true
                                }
                            }
                        })
                }

                if tryGame {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).frame(
                                width: 200,
                                height: 40,
                                alignment: .center
                            ).foregroundColor(.orange)
                            Text(NSLocalizedString("Exit Game", comment: ""))
                                .font(Font.custom("Bebas Neue", size: 25))
                                .foregroundColor(.white)
                                .shadow(
                                    color: .black.opacity(0.8),
                                    radius: 1,
                                    x: 0,
                                    y: 0
                                )
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                        }
                    }
                }
            }
            .onChange(
                of: viewModel.gameWon,
                perform: { value in
                    if value {
                        viewModel.stopGameTimer()
                    }
                }
            )
            .gesture(
                MagnificationGesture(minimumScaleDelta: 1.0)
                    .onChanged { value in
                        if value >= 1.0 {
                            self.areButtonsDisabled = true
                        }
                    }
                    .onEnded { _ in
                        self.areButtonsDisabled = false
                    }
            )

        }
    }
}

struct ThinkGame<CardContent: Equatable> {
    var cards: [Card]

    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [Card]()
        for index in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(index)
            cards.append(Card(id: index * 2, content: content))
            cards.append(Card(id: index * 2 + 1, content: content))
        }
        cards.shuffle()
    }
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
            !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content
                    == cards[potentialMatchIndex].content
                {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }

    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp }.only
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }

    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
