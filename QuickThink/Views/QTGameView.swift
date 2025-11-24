//
//  ContentView.swift
//  QuickThink
//
//  Created by Joseph DeWeese on 11/24/25.
//

import SwiftUI

struct QTGameView: View {
    //MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode

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
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 30))
                            Text("Back")
                                .font(.custom("Bebas Neue", size: 30))
                                .multilineTextAlignment(.center)
                        }
                    })
                }
                .foregroundColor(.white)
                Spacer()
                Text("Brain Game")
                    .font(.custom("Bebas Neue", size: 35))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .foregroundColor(.white)
                Spacer()

            }

        }
    }
}

#Preview {
    QTGameView()
}
