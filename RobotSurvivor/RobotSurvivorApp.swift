//
//  RobotSurvivorApp.swift
//  RobotSurvivor
//
//  Created by Giuseppe Francione on 05/12/23.
//

import SwiftUI

@main
struct RobotSurvivorApp: App {
    
    var body: some Scene {
        WindowGroup {
            ParentView()
                .preferredColorScheme(.light).statusBarHidden(true)
        }
    }
}
