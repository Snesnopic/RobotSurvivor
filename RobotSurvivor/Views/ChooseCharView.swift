//
//  ChooseCharView.swift
//  Robot Survivor
//
//  Created by Giuseppe Francione on 09/02/24.
//

import SwiftUI
import _SpriteKit_SwiftUI

struct ChooseCharView: View {
    var body: some View {
        ZStack {
            Image("cpuPower")
                .interpolation(.none)
                .resizable()
                .offset(y:25)
                .frame(width: 370,height: 400)
            Text("Choose character")
                .tracking(3.0)
                .font(.custom("Silkscreen-Bold", size: 19.0))
                .foregroundStyle(.white)
            ScrollView(.horizontal,showsIndicators: false) {

                LazyHStack(alignment: .center)
                 {
                    ForEach(skins, id: \.self) {
                        skin in
                        PixelArtButtonView(buttonImage: "ButtonPlay1",
                                           pressedImage: "ButtonPlay2",
                                           scene: SkinPreviewScene(skin: skin))
                        .frame(width: 100,height: 100)
                    }
                 }.contentShape(Rectangle())
            }.onTapGesture {
                
            }
            .padding(.top, 120)
            .padding(.horizontal, 50)
        }
    }
}

#Preview {
    ChooseCharView()
}
