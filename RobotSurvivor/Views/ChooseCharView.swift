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
    
    @State private var isPressed: Bool = false
    var index: Int = 0
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
                .padding(.bottom, 170)
            
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack(alignment: .center) {
                    ForEach(Array(zip(skins, localizedSkins)), id: \.0) { skin, localizedSkin in
                        VStack {
                            Button(action: {
                                selectedChar = skin
                            }, label: {
                                if skin == selectedChar {
                                    SpriteView(scene: SkinPreviewScene(skin: skin, isActive: true), options: [.allowsTransparency])
                                } else {
                                    SpriteView(scene: SkinPreviewScene(skin: skin, isActive: false), options: [.allowsTransparency])
                                        .grayscale(1)
                                }
                            })
                            .frame(width: 100, height: 100)
                            Text(localizedSkin)
                                .font(.custom("Silkscreen-Regular", size: 12.0))
                                .foregroundStyle(.white)
                        }
                    }

                }
            }
            .padding(.bottom, 100)
            .padding(.horizontal, 455)
            
            Text("Choose character")
                .font(.custom("Silkscreen-Bold", size: 20.0))
                .foregroundStyle(.white)
                .padding(.bottom, 260)
            PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2",buttonPressedAction: {
                withAnimation{
                    currentGameState = .playing
                }
            }, textView: Text("Play") .font(.custom("Silkscreen-Regular", size: 50)), textColor: .white)
            .frame(width: 224, height:96)
            .padding(.top, 450)
            
            PixelArtButtonView(buttonImage: "circle1", pressedImage: "circle2",buttonPressedAction: {
                withAnimation{
                    self.currentGameState = .mainScreen
                }
            }, textView: Text("<")
                .font(.custom("Silkscreen-Bold", size: 30)), textColor: .white, textOffset: -2)
            .responsiveFrame(widthPercentage: 13, heightPercentage: 7)
            .offset(CGSize(width: -140.0, height: -360.0))
        }
    }
}

#Preview("English") {
    ChooseCharView(selectedChar: .constant("AntiTank"), currentGameState: .constant(.chooseChar))
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Italian") {
    ChooseCharView(selectedChar: .constant("AntiTank"), currentGameState: .constant(.chooseChar))
        .environment(\.locale, Locale(identifier: "IT"))
}
