//
//  PauseMenuView.swift
//  UntitledGame
//
//  Created by Maya Navarrete Moncada on 15/12/23.
//

import SwiftUI

struct PauseMenuView: View {
    var body: some View {
        ZStack{
            Image("pauseMenu")
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .padding(.horizontal)
            
            
            VStack{
//                Text("you Paused")
//                    .font(.custom ("Silkscreen-Bold", size: 30))
//                    .foregroundStyle(.white)
//                    .tracking(-3)
//                    .padding(.bottom, 1)
                
                HStack{
                    
                    PixelArtButtonView(buttonImage: "exitUp", pressedImage: "exitDown", buttonPressedAction: {
                        //TODO: add navigation to main menu
                    })
                    .frame(width:67, height: 76.5)

                    
                    PixelArtButtonView(buttonImage: "playUp", pressedImage: "playDown", buttonPressedAction: {
                        //TODO: add return to gamee
                    })
                    .frame(width:94, height: 102)
                    
                    PixelArtButtonView(buttonImage: "settingsUp", pressedImage: "settingsDown", buttonPressedAction: {
                        //TODO: add navigation to settings
                    })
                    .frame(width:67, height: 76.5)
                }
            }
        }
    }
}

#Preview {
    PauseMenuView()
}
