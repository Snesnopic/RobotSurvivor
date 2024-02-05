//
//  CGPointExtension.swift
//  Robot Survivor
//
//  Created by Giuseppe Casillo on 21/12/23.
//

import AVFoundation

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
