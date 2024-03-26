//
//  SettingOptions.swift
//  Robot Survivor
//
//  Created by Davide Castaldi on 26/03/24.
//

import SwiftUI

struct SettingOptions: View {
    @ObservedObject var gameLogic: GameLogic
    @Binding var switchMusic: Bool
    @Binding var switchSound: Bool
    @Binding var music: Int
    @Binding var sounds: Int
    //this is because since the text are variables now, they have to be localized keys otherwise they won't be localized
    var titleOfOption: LocalizedStringKey
    var subtitleOfOption: LocalizedStringKey
    
    var body: some View {
        VStack{
            
            HStack{
                Text(titleOfOption)
                    .responsiveFrame(heightPercentage: 10)
                    
                Spacer()
                Image(switchMusic ? "OnSwitch1" : "OffSwitch1")
                    .resizable()
                    .scaledToFit()
                    .responsiveFrame(widthPercentage: 10, heightPercentage: 10)
                    .onTapGesture {
                        switchMusic.toggle()
                    }
                
            }
            .font(.custom("Silkscreen-Bold", size: 24))
            .responsiveFrame(widthPercentage: 50, heightPercentage: 5, alignment: .center)
            
            HStack{
                Text(subtitleOfOption)
                    .tracking(-2.5)
                Spacer()
                PixelArtButtonView(buttonImage: "minus1", pressedImage: "minus2",buttonPressedAction: {
                    //TODO: add volume levels
                    if(music > 0){
                        music = music - 1;
                    }
                }, textView: Text(""))
                .responsiveFrame(widthPercentage: 5, aspectRatio: (1, 0.1))
                
                Text(String(music))
                    .offset(x: 1.5)
                
                PixelArtButtonView(buttonImage: "plus1", pressedImage: "plus2",buttonPressedAction: {
                    //TODO: add volume levels
                    if(music < 10){
                        music = music + 1;
                    }
                }, textView: Text(""))
                .responsiveFrame(widthPercentage: 6, heightPercentage: 3)
            }
            .font(.custom("Silkscreen-Regular", size: 22))
            .responsiveFrame(widthPercentage: 50, heightPercentage: 5, alignment: .center)
        }
        .responsiveFrame(heightPercentage: 15)
    }
}

#Preview("English"){
    SettingOptions(gameLogic: GameLogic.shared, switchMusic: .constant(true), switchSound: .constant(true), music: .constant(5), sounds: .constant(5), titleOfOption: "Sound \nEffects", subtitleOfOption: "Volume")
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Italian"){
    SettingOptions(gameLogic: GameLogic.shared, switchMusic: .constant(true), switchSound: .constant(true), music: .constant(5), sounds: .constant(5), titleOfOption: "Sound \nEffects", subtitleOfOption: "Volume")
        .environment(\.locale, Locale(identifier: "IT"))
}
