//
//  DurationView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI

struct DurationView: View {
    @Binding var time: TimeInterval
    var body: some View {
        GeometryReader{ geometry in
            Text(String(time.minuteSecond))
                .font(.custom("Silkscreen-Regular", size: 20))
                .foregroundStyle(.white)
                .position(CGPoint(x: geometry.size.width/2 , y: 80))
        }
    }
}
//#Preview {
//    DurationView()
//}
