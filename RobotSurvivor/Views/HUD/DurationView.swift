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
            Text("Time")
                .font(.custom("Silkscreen-Regular", size: 30))
                .foregroundStyle(.white)
                .position(CGPoint(x: geometry.size.width/6.5, y: 60) )
            Text(String(time.minuteSecond))
                .font(.custom("Silkscreen-Regular", size: 30))
                .foregroundStyle(.white)
                .position(CGPoint(x: geometry.size.width/6.5 , y: 90))
        }
    }
}
#Preview {
    DurationView(time: .constant(TimeInterval(581)))
        .background {
            Color.black
        }
}
