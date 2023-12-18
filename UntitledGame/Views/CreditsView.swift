//
//  CreditsView.swift
//  Robot Survivor
//
//  Created by Maya Navarrete Moncada on 18/12/23.
//

import SwiftUI

struct CreditsView: View {
    
    @Binding var showCredit: Bool
    var body: some View {
        ZStack{
            Color.deadBlue
                .ignoresSafeArea()
            
            Image("chip3")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .offset(x: -34)
                .opacity(0.6)
            
            
            Image("cpuVert")
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .scaleEffect(x: 1, y: -1)
                .frame(width: 360)
                .shadow(radius: 20)
                .padding(.top, 50)
            
            VStack{
                
                PixelArtButtonView(buttonImage: "circle1", pressedImage: "circle2",buttonPressedAction: {
                    showCredit = false
                }, textView: Text("x")
                    .font(.custom("Silkscreen-Bold", size: 25)), textColor: .white)
                .frame(width:50, height: 57)
                .shadow(radius: 15)
                .padding(.leading, 275)
                
                Text("Created by:")
                    .font(.custom ("Silkscreen-Bold", size: 23))
                    .foregroundStyle(.white)
                    .tracking(-3)
                    .padding(.top, 245)
                
                Text("\nGiuseppe Casillo\nGiuseppe Francione\nMaya Navarrete\nClaudio Pepe\nLinar Zinatullin")
                    .font(.custom ("Silkscreen-Regular", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .tracking(-3)
                
                Spacer()
            }
        }
    }
}

#Preview {
    CreditsView(showCredit: .constant(true))
}
