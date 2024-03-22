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
                    .frame(width: 360)
                    .shadow(radius: 20)
                    .padding(.top, 50)
                
                PixelArtButtonView(buttonImage: "circle1", pressedImage: "circle2",buttonPressedAction: {
                    dismiss()
                }, textView: Text("x")
                    .font(.custom("Silkscreen-Bold", size: 25)), textColor: .white)
                .frame(width:50, height: 57)
                .shadow(radius: 15)
                .padding(.leading, 275)
                .padding(.bottom,700)
                VStack{
                    
                    Text("Settings")
                        .tracking(-2.5)
                        .font(.custom("Silkscreen-Bold", size: 30))
                        .shadow(radius: 15)
                        .padding(.top, 50)
                    
                    HStack{
                        Text("Music")
                            .tracking(-2.5)
                            .padding(.trailing, 35)
                        Image(switchMusic ? "OnSwitch1" : "OffSwitch1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .onTapGesture {
                                switchMusic.toggle()
                            }
                        
                    }
                    .font(.custom("Silkscreen-Bold", size: 25))
                    .padding(.bottom, 7)
                    
                    HStack{
                        Text("Volume")
                            .tracking(-2.5)
                            .padding(.trailing, 10)
                        
                        PixelArtButtonView(buttonImage: "minus1", pressedImage: "minus2",buttonPressedAction: {
                            //TODO: add volume levels
                            if(music > 0){
                                music = music - 1;
                            }
                        }, textView: Text(""))
                        .frame(width:28, height:12)
                        
                        Text(String(music))
                        
                        PixelArtButtonView(buttonImage: "plus1", pressedImage: "plus2",buttonPressedAction: {
                            //TODO: add volume levels
                            if(music < 10){
                                music = music + 1;
                            }
                        }, textView: Text(""))
                        .frame(width:32, height:32)
                    }
                    .font(.custom("Silkscreen-Regular", size: 20))
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Text("Sound \nEffects")
                            .tracking(-2.5)
                            .multilineTextAlignment(.leading)
                            .padding(.trailing, 10)
                        Image(switchSound ? "OnSwitch1" : "OffSwitch1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .onTapGesture {
                                switchSound.toggle()
                            }
                        
                    }
                    .font(.custom("Silkscreen-Bold", size: 25))
                    .padding(.bottom, 7)
                    
                    HStack{
                        Text("Volume")
                            .tracking(-2.5)
                            .padding(.trailing, 10)
                        
                        PixelArtButtonView(buttonImage: "minus1", pressedImage: "minus2",buttonPressedAction: {
                            //TODO: add volume levels
                            if(sounds > 0){
                                sounds = sounds - 1
                            }
                        }, textView: Text(""))
                        .frame(width:28, height:12)
                        
                        Text(String(sounds))
                        
                        PixelArtButtonView(buttonImage: "plus1", pressedImage: "plus2",buttonPressedAction: {
                            //TODO: add volume levels
                            if(sounds < 10){
                                sounds = sounds + 1
                            }
                        }, textView: Text(""))
                        .frame(width:32, height:32)
                    }
                    .font(.custom("Silkscreen-Regular", size: 20))
                    .padding(.bottom, 25)
                    
                    
                    
                    PixelArtButtonView(buttonImage: "ButtonSett1", pressedImage: "ButtonSett2",buttonPressedAction: {
                        //TODO: add navigation to credits
                        showCredits.toggle()
                    }, textView: Text("Credits") .font(.custom("Silkscreen-Bold", size: 20)), textColor: .white)
                    .frame(width: 144, height: 50)
                    .padding(.bottom)
                    .offset(y: 10)
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
