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
        ZStack {
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
                .padding(.top, 25)
            PixelArtButtonView(buttonImage: "circle1", pressedImage: "circle2", buttonPressedAction: {
                showCredit = false
            }, textView: Text("x")
                .font(.custom("Silkscreen-Bold", size: 25)), textColor: .white)
            .responsiveFrame(widthPercentage: 13, heightPercentage: 7)
            .shadow(radius: 15)
            .padding(.leading, 275)
            .padding(.bottom, 700)
            VStack {

                Text("Created by:")
                    .tracking(-3)
                    .font(.custom("Silkscreen-Bold", size: 23))
                    .foregroundStyle(.white)
                    .padding()
                ForEach(creators, id: \.self) {creator in
                    Text(creator)
                        .tracking(-3)
                        .font(.custom("Silkscreen-Regular", size: 22))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                }
            }
        }
        .statusBarHidden(true)
    }
}

#Preview {
    CreditsView(showCredit: .constant(true))
}
