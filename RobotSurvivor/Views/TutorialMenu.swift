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
        String(localized:"Drag to move and shoot the endless enemies!"),
        String(localized:"Collect XP left from enemies to fill the xp bar!"),
        String(localized:"Fill the xp bar to obtain power-ups!")
    ]
    
    var body: some View {
        ZStack{
            Color.deadBlue
                .ignoresSafeArea()
            
            Image("chip2")
                .interpolation(.none)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .offset(x: -34)
                .opacity(0.6)
            
            PixelArtButtonView(buttonImage: "circle1", pressedImage: "circle2",buttonPressedAction: {
                dismiss()
            }, textView: Text("x")
                .font(.custom("Silkscreen-Bold", size: 25)), textColor: .white)
            .frame(width:50, height: 57)
            .shadow(radius: 15)
            .padding(.leading, 275)
            .padding(.bottom, 700)
            
            Image("cpuHor")
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 365, height: 600, alignment: .center)
            Text(tutorialSteps[currentStep])
                .font(.custom("Silkscreen-Regular", size: 19))
                .foregroundStyle(.white)
                .frame(width: 240, height: 150, alignment: .topLeading)
            
            PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2", buttonPressedAction: {
                withAnimation {
                    if currentStep >= 2 {
                        dismiss()
                        
                    } else {
                        currentStep += 1
                    }
                }
            }, textView: Text(currentStep != 2 ? "next" : "done") .font(.custom("Silkscreen-Regular", size: 15)), textColor: .white)
            .frame(width: 50, height: 35)
            .padding(.top, 125)
            .offset(x: 100, y: 0)
            .shadow(radius: 15)
            
            PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2", buttonPressedAction: {
                withAnimation {
                    currentStep -= 1
                }
            }, textView: Text("back") .font(.custom("Silkscreen-Regular", size: 15)), textColor: .white)
            .frame(width: 50, height: 35)
            .padding(.top, 125)
            .offset(x: 45, y: 0)
            .shadow(radius: 15)
            .opacity(currentStep >= 1 ? 1 : 0)
            
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
