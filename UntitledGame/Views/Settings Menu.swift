//
//  Settings Menu.swift
//  UntitledGame
//
//  Created by Maya Navarrete Moncada on 13/12/23.
//


import SwiftUI

struct Settings_Menu: View {
    @Environment(\.dismiss) private var dismiss
    
    @Environment(GameLogic.self)
    var gameLogic: GameLogic
    

    @State var showCredits: Bool = false
    var body: some View {
        if(!showCredits){
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
                        dismiss()
                    }, textView: Text("x")
                        .font(.custom("Silkscreen-Bold", size: 25)), textColor: .white)
                    .frame(width:50, height: 57)
                    .shadow(radius: 15)
                    .padding(.leading, 275)
                    
                    
                    Text("Settings")
                        .font(.custom("Silkscreen-Bold", size: 50))
                        .shadow(radius: 15)
                        .padding(.bottom, 105)
                    
                    HStack{
                        Text("Music")
                            .padding(.trailing, 35)
                        Image(gameLogic.musicSwitch ? "OnSwitch1" : "OffSwitch1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .onTapGesture {
                                gameLogic.musicSwitch.toggle()
                            }
                        
                    }
                    .font(.custom("Silkscreen-Bold", size: 25))
                    .padding(.bottom, 7)
                    
                    HStack{
                        Text("Volume")
                            .padding(.trailing, 10)
                        
                        PixelArtButtonView(buttonImage: "minus1", pressedImage: "minus2",buttonPressedAction: {
                            //TODO: add volume levels
                            if(gameLogic.musicVolume > 0){
                                gameLogic.musicVolume -= 1;
                            }
                        }, textView: Text(""))
                        .frame(width:28, height:12)
                        
                        Text(String(gameLogic.musicVolume))
                        
                        PixelArtButtonView(buttonImage: "plus1", pressedImage: "plus2",buttonPressedAction: {
                            //TODO: add volume levels
                            if(gameLogic.musicVolume < 10){
                                gameLogic.musicVolume += 1;
                            }
                        }, textView: Text(""))
                        .frame(width:32, height:32)
                    }
                    .font(.custom("Silkscreen-Regular", size: 20))
                    .padding(.bottom, 20)
                    
                    
                    HStack{
                        Text("Sound \nEffects")
                            .multilineTextAlignment(.leading)
                            .padding(.trailing, 10)
                        Image(gameLogic.soundsSwitch ? "OnSwitch1" : "OffSwitch1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .onTapGesture {
                                gameLogic.soundsSwitch.toggle()
                            }
                        
                    }
                    .font(.custom("Silkscreen-Bold", size: 25))
                    .padding(.bottom, 7)
                    
                    HStack{
                        Text("Volume")
                            .padding(.trailing, 10)
                        
                        PixelArtButtonView(buttonImage: "minus1", pressedImage: "minus2",buttonPressedAction: {
                            //TODO: add volume levels
                            if(gameLogic.soundsVolume > 0){
                                gameLogic.soundsVolume -=  1
                            }
                        }, textView: Text(""))
                        .frame(width:28, height:12)
                        
                        Text(String(gameLogic.soundsVolume))
                        
                        PixelArtButtonView(buttonImage: "plus1", pressedImage: "plus2",buttonPressedAction: {
                            //TODO: add volume levels
                            if(gameLogic.soundsVolume < 10){
                                gameLogic.soundsVolume += 1
                            }
                        }, textView: Text(""))
                        .frame(width:32, height:32)
                    }
                    .font(.custom("Silkscreen-Regular", size: 20))
                    .padding(.bottom, 25)
                    
                    PixelArtButtonView(buttonImage: "ButtonSett1", pressedImage: "ButtonSett2",buttonPressedAction: {
                        //TODO: add navigation to credits
                        showCredits = true
                    }, textView: Text("Credits") .font(.custom("Silkscreen-Bold", size: 20)), textColor: .white)
                    .frame(width: 144, height:48)
                    .padding(.bottom)
                    .shadow(radius: 15)
                    
                    
                    Spacer()
                    
                }
                .foregroundStyle(.white)
                .tracking(-2.5)
            }
        }else{
            CreditsView(showCredit: $showCredits)
        }
    }
}

//#Preview {
//    Settings_Menu()
//}
