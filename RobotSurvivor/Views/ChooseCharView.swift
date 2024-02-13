//
//  ChooseCharView.swift
//  Robot Survivor
//
//  Created by Giuseppe Francione on 09/02/24.
//

import SwiftUI
import _SpriteKit_SwiftUI

struct ChooseCharView: View {
    @Binding var selectedChar:String
    @Binding var currentGameState: GameState
    var body: some View {
        ZStack {
            Color.deadBlue.ignoresSafeArea()
            
            Image("chip3")
                .interpolation(.none)
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.6)
            Image("cpuPower")
                .interpolation(.none)
                .resizable()
                .frame(width: 370,height: 400)
                .padding(.bottom,50)
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack(alignment: .center)
                {
                    ForEach(skins, id: \.self) {
                        skin in
                        VStack {
                            Button(action: {
                                selectedChar = skin
                            }, label: {
                                if(skin == selectedChar){
                                    SpriteView(scene: SkinPreviewScene(skin: skin,isActive: true),options: [.allowsTransparency])
                                }
                                else{
                                    SpriteView(scene: SkinPreviewScene(skin: skin,isActive: false),options: [.allowsTransparency])
                                        .grayscale(1)
                                }
                            })
                            .frame(width: 100,height: 100)
                            Text(skin)
                                .font(.custom("Silkscreen-Regular", size: 12.0)).foregroundStyle(.white)
                        }
                    }
                }
            }
            .padding(.top, 50)
            .padding(.horizontal, 455)
            
            Text("Choose character")
                .tracking(3.0)
                .font(.custom("Silkscreen-Bold", size: 19.0))
                .foregroundStyle(.white)
                .padding(.bottom,110)
            PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2",buttonPressedAction: {
                withAnimation{currentGameState = .playing}
            }, textView: Text("Play") .font(.custom("Silkscreen-Regular", size: 50)), textColor: .white)
            .frame(width: 224, height:96)
            .padding(.top, 500)
        }
    }
}

#Preview {
    ChooseCharView(selectedChar: .constant("AntiTank"), currentGameState: .constant(.chooseChar))
}
