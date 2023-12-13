//
//  MainMenuView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI
import AVFoundation

struct MainMenuView: View {
    @Binding var currentGameState: GameState
    
    @State var audioPlayer:AVAudioPlayer?
    var body: some View {
        ZStack{
            Color.darkGreen
                .ignoresSafeArea()
            
            VStack{
                
                Spacer()
                
                Image(systemName: "cpu")
                    .font(.system(size: 70))
                    .padding(.bottom, -20)
                    .foregroundColor(.green)
                
                Text("Robot")
                    .font(.custom("Silkscreen-Bold", size: 65))
                    .foregroundStyle(.green)
                Text("Survivor")
                    .font(.custom("Silkscreen-Bold", size: 39))
                    .foregroundStyle(.green)
                    .padding(.bottom, 75)
                
                Button(action: {
                    currentGameState = .playing
                }, label: {
                    Text("Play")
                })
                .font(.custom("Silkscreen-Regular", size: 50))
                .frame(width: 225, height:85)
                .background(RoundedRectangle(cornerRadius: 10.0).fill(.green.opacity(0.3)))
                .foregroundStyle(.green)
                
                .padding(.bottom)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Settings")
                })
                .font(.custom("Silkscreen-Regular", size: 25))
                .frame(width: 225, height:50)
                .background(RoundedRectangle(cornerRadius: 10.0).fill(.green.opacity(0.3)))
                .foregroundStyle(.green)
                
                Spacer()
                
            }
        }.onAppear(perform: {
            do {
                let path = Bundle.main.url(forResource: "mainmenu", withExtension: "mp3")
                audioPlayer = try AVAudioPlayer(contentsOf: path!)
                audioPlayer!.play()
                audioPlayer!.volume = 1
                print("I am now playing!! Proof: \(audioPlayer!.isPlaying)")
            }
            catch {
                
            }
        })
    }
}

//#Preview {
//    MainMenuView(currentGameState: )
//}
