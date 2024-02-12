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
    var body: some View {
        ZStack {
            Image("cpuPower")
                .interpolation(.none)
                .resizable()
                .offset(y:25)
                .frame(width: 370,height: 400)
            
            ScrollView(.horizontal,showsIndicators: false) {
                LazyHStack(alignment: .center)
                {
                    ForEach(skins, id: \.self) {
                        skin in
                        VStack {
                            Button(action: {
                                selectedChar = skin
                                print("New value: \(selectedChar)")
                            }, label: {
                                SpriteView(scene: SkinPreviewScene(skin: skin,isActive: skin == selectedChar),options: [.allowsTransparency])
                            })
                            .frame(width: 100,height: 100)
                            Text(skin)
                                .font(.custom("Silkscreen-Regular", size: 12.0)).foregroundStyle(.white)
                        }
                        
                    }
                }
            }
            .padding(.top, 120)
            .padding(.horizontal, 50)
            
            Text("Choose character")
                .tracking(3.0)
                .font(.custom("Silkscreen-Bold", size: 19.0))
                .foregroundStyle(.white)
            
        }
    }
}

#Preview {
    ChooseCharView(selectedChar: .constant("AntiTank"))
}
