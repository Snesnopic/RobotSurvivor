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
        String(localized: "Fill the top bar to obtain power-ups!")
    ]
   
    var body: some View {
        ZStack {
            
            Image("pauseMenu")
                .interpolation(.none)
                .resizable()
                .scaledToFit()
            Text(tutorialSteps[currentStep])
                .font(.custom("Silkscreen-Regular", size: 19))
                .foregroundStyle(.white)
                .frame(width: 240, height: 150, alignment: .topLeading)
            
            PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2", buttonPressedAction: {
                withAnimation {
                    if currentStep == 2 && gameLogic.showTutorial {
                        gameLogic.showTutorial = false;
                        self.presentationMode.wrappedValue.dismiss()
                        
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
                    if currentStep == 0 && gameLogic.showTutorial {
                        currentStep = 0
                        
                    } else {
                        currentStep -= 1
                    }
                }
            }, textView: Text("back") .font(.custom("Silkscreen-Regular", size: 15)), textColor: .white)
            .frame(width: 50, height: 35)
            .padding(.top, 125)
            .offset(x: 45, y: 0)
            .shadow(radius: 15)
            .opacity(currentStep >= 1 ? 1 : 0)
            
            Image("cpuHor")
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .offset(y: 310)
            PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2", buttonPressedAction: {
                gameLogic.showTutorial = false
                self.presentationMode.wrappedValue.dismiss()
            }, textView: Text("skip") .font(.custom("Silkscreen-Regular", size: 15)), textColor: .white)
            .frame(width: 50, height: 35)
            .padding(.top, 125)
            .offset(y: 248)
            .shadow(radius: 15)
        }
        .padding()
        .onDisappear {
            saveTutorialStatus()
        }
        .onAppear {
            loadTutorialStatus() 
        }
    }
    func saveTutorialStatus() {
        UserDefaults.standard.set(gameLogic.showTutorial, forKey: "showTutorial")
    }
    
    func loadTutorialStatus() {
            UserDefaults.standard.bool(forKey: "showTutorial")
    }
}


#Preview {
    TutorialView(gameLogic: GameLogic.shared, currentGameState: .constant(GameState.playing), sceneWrap: .constant(SceneWrapper()))
}
