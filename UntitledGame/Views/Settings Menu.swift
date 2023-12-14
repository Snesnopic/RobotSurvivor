//
//  Settings Menu.swift
//  UntitledGame
//
//  Created by Maya Navarrete Moncada on 13/12/23.
//


import SwiftUI

struct Settings_Menu: View {
    @Environment(\.dismiss) private var dismiss
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
                    Image("OffSwitch1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        
                }
                .font(.custom("Silkscreen-Bold", size: 25))
                .padding(.bottom, 7)
                
                HStack{
                    Text("Volume")
                        .padding(.trailing, 10)
                    
                    PixelArtButtonView(buttonImage: "minus1", pressedImage: "plus2",buttonPressedAction: {
                        //TODO: add volume levels
                    }, textView: Text(""))
                    .frame(width:28, height:12)
                    
                    Text("9")
                    
                    PixelArtButtonView(buttonImage: "plus1", pressedImage: "minus2",buttonPressedAction: {
                        //TODO: add volume levels
                    }, textView: Text(""))
                    .frame(width:32, height:32)
                }
                .font(.custom("Silkscreen-Regular", size: 20))
                .padding(.bottom, 20)
                
                
                HStack{
                    Text("Sound \nEffects")
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 10)
                    Image("OnSwitch1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        
                }
                .font(.custom("Silkscreen-Bold", size: 25))
                .padding(.bottom, 7)
                
                HStack{
                    Text("Volume")
                        .padding(.trailing, 10)
                    
                    PixelArtButtonView(buttonImage: "plus1", pressedImage: "plus2",buttonPressedAction: {
                        //TODO: add volume levels
                    }, textView: Text(""))
                    .frame(width:32, height:32)
                    
                    Text("9")
                    
                    PixelArtButtonView(buttonImage: "minus1", pressedImage: "minus2",buttonPressedAction: {
                        //TODO: add volume levels
                    }, textView: Text(""))
                    .frame(width:28, height:12)
                }
                .font(.custom("Silkscreen-Regular", size: 20))
                .padding(.bottom, 25)
                
                PixelArtButtonView(buttonImage: "ButtonSett1", pressedImage: "ButtonSett2",buttonPressedAction: {
                    //TODO: add navigation to credits
                }, textView: Text("Credits") .font(.custom("Silkscreen-Bold", size: 20)), textColor: .white)
                .frame(width: 144, height:48)
                .padding(.bottom)
                .shadow(radius: 15)
                
                
                Spacer()
                
            }
            .foregroundStyle(.white)
            .tracking(-2.5)
        }
    }
}

#Preview {
    Settings_Menu()
}
