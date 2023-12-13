//
//  Settings Menu.swift
//  UntitledGame
//
//  Created by Maya Navarrete Moncada on 13/12/23.
//


import SwiftUI

struct Settings_Menu: View {
    var body: some View {
        Text("Settings")
        Text("Volume")
        Text("Sound Effects")
        Text("Volume")
        Text("Credits")
        
        ZStack{
            Image("FrameHor")
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            Text("Credits")
                .font(.custom("Silkscreen-Regular", size: 25))
        }
    }
}

#Preview {
    Settings_Menu()
}
