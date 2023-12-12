//
//  MainMenuView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        VStack{
            
            Spacer()
            
            Text("Robot")
                .font(.custom("Silkscreen-Bold", size: 65))
            Text("Survivor")
                .font(.custom("Silkscreen-Bold", size: 39))
                .padding(.bottom, 75)
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Play")
            })
            .font(.custom("Silkscreen-Regular", size: 50))
            .padding(.bottom)
            .foregroundStyle(.green)
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Settings")
            })
            .font(.custom("Silkscreen-Regular", size: 25))
            .foregroundStyle(.green)
            
            Spacer()
            
        }
    }
}

#Preview {
    MainMenuView()
}
