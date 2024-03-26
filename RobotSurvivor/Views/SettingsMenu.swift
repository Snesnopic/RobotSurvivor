//
//  Settings Menu.swift
//  UntitledGame
//
//  Created by Maya Navarrete Moncada on 13/12/23.
//


import SwiftUI

struct Settings_Menu: View {
    @ObservedObject var gameLogic: GameLogic
    @Environment(\.dismiss) private var dismiss
    @Binding var switchMusic: Bool
    @Binding var switchSound: Bool
    @Binding var music: Int
    @Binding var sounds: Int
    @State var showCredits: Bool = false
    var body: some View {
        if(!showCredits){
            ZStack{
                Color.deadBlue
                    .ignoresSafeArea()
                
                Image("chip3")
                    .interpolation(.none)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .offset(x: -34)
                    .opacity(0.6)
                
                Image("cpuVert")
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(x: 1, y: -1.2)
                    .responsiveFrame(widthPercentage: 90)
                    .shadow(radius: 20)
                                    
                PixelArtButtonView(buttonImage: "circle1", pressedImage: "circle2",buttonPressedAction: {
                    dismiss()
                }, textView: Text("x")
                    .font(.custom("Silkscreen-Bold", size: 25)), textColor: .white)
                .responsiveFrame(widthPercentage: 13, heightPercentage: 7)
                .shadow(radius: 15)
                .padding(.leading, 275)
                .padding(.bottom,700)
                
                VStack{
                    
                    Text("Settings")
                        .tracking(-2.5)
                        .font(.custom("Silkscreen-Bold", size: 26))
                        .shadow(radius: 15)
                    
                    //this is a view i made so that everytime we need the option that requires volume, it's more easily modifiable and also makes the code more readable and consistent than earlier
                    
                    SettingOptions(gameLogic: GameLogic.shared, switchMusic: $switchMusic, switchSound: $switchSound, music: $music, sounds: $sounds, titleOfOption: "Music", subtitleOfOption: "Volume")
                    
                    SettingOptions(gameLogic: GameLogic.shared, switchMusic: $switchMusic, switchSound: $switchSound, music: $music, sounds: $sounds, titleOfOption: "Sound \nEffects", subtitleOfOption: "Volume")
                    
                    PixelArtButtonView(buttonImage: "ButtonSett1", pressedImage: "ButtonSett2",buttonPressedAction: {
                        //TODO: add navigation to credits
                        showCredits.toggle()
                    }, textView: Text("Credits") .font(.custom("Silkscreen-Bold", size: 16)), textColor: .white)
                    .responsiveFrame(widthPercentage: 50, heightPercentage: 5, alignment: .center)
                    .shadow(radius: 15)
                    
                }
                .foregroundStyle(.white)
            }
            .statusBarHidden(true)

        }else{
            CreditsView(showCredit: $showCredits)
        }
    }
}

#Preview("English"){
    Settings_Menu(gameLogic: GameLogic.shared, switchMusic: .constant(true), switchSound: .constant(true), music: .constant(5), sounds: .constant(5))
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Italian"){
    Settings_Menu(gameLogic: GameLogic.shared, switchMusic: .constant(true), switchSound: .constant(true), music: .constant(5), sounds: .constant(5))
        .environment(\.locale, Locale(identifier: "IT"))
}
