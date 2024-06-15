//
//  TutorialMenu.swift
//  Robot Survivor
//
//  Created by Davide Castaldi on 09/02/24.
//

import SwiftUI

struct TutorialMenu: View {

    @State var currentStep: Int = 0
    @Environment(\.dismiss) private var dismiss

    var tutorialSteps: [String] = [
        String(localized: "Drag to move and shoot the endless enemies!"),
        String(localized: "Collect XP left from enemies to fill the xp bar!"),
        String(localized: "Fill the xp bar to obtain power-ups!")
    ]

    var body: some View {
        ZStack {
            Color.deadBlue
                .ignoresSafeArea()

            Image("chip2")
                .interpolation(.none)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .offset(x: -34)
                .opacity(0.6)

            PixelArtButtonView(buttonImage: "circle1", pressedImage: "circle2", buttonPressedAction: {
                dismiss()
            }, textView: Text("x")
                .font(.custom("Silkscreen-Bold", size: 25)), textColor: .white)
            .responsiveFrame(widthPercentage: 13, heightPercentage: 7)
            .shadow(radius: 15)
            .padding(.leading, 275)
            .padding(.bottom, 700)

            Image("cpuHor")
                .interpolation(.none)
                .resizable()
                .responsiveFrame(widthPercentage: 95, heightPercentage: 40, alignment: .center)
            VStack {
                Text(tutorialSteps[currentStep])
                    .font(.custom("Silkscreen-Regular", size: 19))
                    .foregroundStyle(.white)
                Spacer()
                HStack {

                    PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2", buttonPressedAction: {
                        withAnimation {
                            currentStep -= 1
                        }
                    }, textView: Text("back") .font(.custom("Silkscreen-Regular", size: 15)), textColor: .white)
                    .responsiveFrame(widthPercentage: 25, heightPercentage: 4)
                    .shadow(radius: 15)
                    .opacity(currentStep >= 1 ? 1 : 0)

                    PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2", buttonPressedAction: {
                        withAnimation {
                            if currentStep >= 2 {
                                dismiss()

                            } else {
                                currentStep += 1
                            }
                        }
                    }, textView: Text(currentStep != 2 ? "next" : "done")
                        .font(.custom("Silkscreen-Regular", size: 15)), textColor: .white)

                    .responsiveFrame(widthPercentage: 25, heightPercentage: 4)
                    .shadow(radius: 15)
                }
                .padding(.leading, 50)
            }
            .responsiveFrame(widthPercentage: 60, heightPercentage: 20)

        }
        .statusBarHidden(true)
    }
}

#Preview("English") {
    TutorialMenu()
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Italian"){
    TutorialMenu()
        .environment(\.locale, Locale(identifier: "IT"))
}
