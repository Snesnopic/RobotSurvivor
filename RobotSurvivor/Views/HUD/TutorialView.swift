//
//  TutorialView.swift
//  Robot Survivor
//
//  Created by Davide Castaldi on 07/02/24.
//

import SwiftUI
import SwiftData

struct TutorialView: View {
    
    @ObservedObject var gameLogic: GameLogic
    @Binding var currentGameState: GameState
    @Binding var sceneWrap: SceneWrapper
    @State var currentStep: Int = 0
    @Environment(\.presentationMode) var presentationMode
    
    var tutorialSteps = [
        String(localized: "Drag to move and shoot the endless enemies!"),
        String(localized: "Collect XP left from enemies to fill the xp bar!"),
        String(localized: "Fill the xp bar to obtain power-ups!")
    ]
    
    var body: some View {
        ZStack {
            
            Image("pauseMenu")
                .interpolation(.none)
                .resizable()
                .responsiveFrame(widthPercentage: 95, heightPercentage: 70, alignment: .center)
            VStack{
                Text(tutorialSteps[currentStep])
                    .font(.custom("Silkscreen-Regular", size: 19))
                    .foregroundStyle(.white)
                Spacer()
                HStack {
                    
                    PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2", buttonPressedAction: {
                        withAnimation {
                            currentStep = (currentStep == 0 && gameLogic.showTutorial) ? 0 : currentStep - 1
                        }
                    }, textView: Text("back") .font(.custom("Silkscreen-Regular", size: 15)), textColor: .white)
                    .responsiveFrame(widthPercentage: 25, heightPercentage: 4)
                    .shadow(radius: 15)
                    .opacity(currentStep >= 1 ? 1 : 0)
                    
                    PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2", buttonPressedAction: {
                        withAnimation {
                            if currentStep == 2 && gameLogic.showTutorial {
                                //MARK: This works as intended. The self.presentationMode.wrappedValue.dismiss() does not work
                                gameLogic.showTutorial = false;
                                presentationMode.wrappedValue.dismiss()
                                
                            } else {
                                currentStep += 1
                            }
                        }
                    }, textView: Text(currentStep != 2 ? "next" : "done")
                        .font(.custom("Silkscreen-Regular", size: 15)), textColor: .white)
                    
                    .responsiveFrame(widthPercentage: 25, heightPercentage: 4)
                }
                .padding(.leading, 50)
            }
            .responsiveFrame(widthPercentage: 60, heightPercentage: 20)
            
            PixelArtButtonView(buttonImage: "circle1", pressedImage: "circle2",buttonPressedAction: {
                //MARK: This doesn't work as intended! Once the x is pressed, it counts as if the player has gone through the tutorial. The dismiss() does not work, also the bool value should not be put to false for this action.
                gameLogic.showTutorial = false
                self.presentationMode.wrappedValue.dismiss()
            }, textView: Text("x")
                .font(.custom("Silkscreen-Bold", size: 22)), textColor: .white)
            .responsiveFrame(widthPercentage: 10, heightPercentage: 5.2)
            .padding(.leading, 280)
            .padding(.bottom, 215)
        }
        .onDisappear {
            UserDefaults.standard.set(gameLogic.showTutorial, forKey: "showTutorial")
        }
        .onAppear {
            UserDefaults.standard.bool(forKey: "showTutorial")
        }

    }
}


#Preview("English") {
    TutorialView(gameLogic: GameLogic.shared, currentGameState: .constant(GameState.playing), sceneWrap: .constant(SceneWrapper.shared))
        .environment(\.locale, Locale(identifier: "EN"))
}


#Preview("Italian") {
    TutorialView(gameLogic: GameLogic.shared, currentGameState: .constant(GameState.playing), sceneWrap: .constant(SceneWrapper.shared))
        .environment(\.locale, Locale(identifier: "IT"))
}
