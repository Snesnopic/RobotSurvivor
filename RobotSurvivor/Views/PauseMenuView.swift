//
//  PauseMenuView.swift
//  UntitledGame
//
//  Created by Maya Navarrete Moncada on 15/12/23.
//

import SwiftUI

struct PauseMenuView: View {
    @ObservedObject var gameLogic: GameLogic
    @Binding var currentGameState: GameState
    @Binding var sceneWrap: SceneWrapper
    @State var showSetting: Bool = false
    var body: some View {
        ZStack {
            Image("pauseMenu")
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .padding()

            VStack {
                HStack {

                    PixelArtButtonView(buttonImage: "exitUp", pressedImage: "exitDown", buttonPressedAction: {
                        gameLogic.showPauseMenu = false
                        self.currentGameState = .mainScreen
                        sceneWrap.scene.stopTracks()
                    })
                    .frame(width: 67, height: 76.5)

                    PixelArtButtonView(buttonImage: "playUp", pressedImage: "playDown", buttonPressedAction: {
                        gameLogic.showPauseMenu = false
                    })
                    .frame(width: 94, height: 102)

                    PixelArtButtonView(buttonImage: "settingsUp", pressedImage: "settingsDown", buttonPressedAction: {

                        showSetting = true
                    }).fullScreenCover(isPresented: $showSetting, content: {
                        Settings_Menu(gameLogic: GameLogic.shared, switchMusic: $gameLogic.musicSwitch, switchSound: $gameLogic.soundsSwitch, music: $gameLogic.musicVolume, sounds: $gameLogic.soundsVolume)
                    })
                    .frame(width: 67, height: 76.5)
                }
            }
        }
    }
}

#Preview {
    PauseMenuView(gameLogic: GameLogic.shared, currentGameState: .constant(GameState.playing), sceneWrap: .constant(SceneWrapper.shared))
}
