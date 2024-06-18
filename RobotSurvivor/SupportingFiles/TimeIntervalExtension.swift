//
//  TimeIntervalExtension.swift
//  UntitledGame
//
//  Created by Giuseppe Casillo on 14/12/23.
//

import Foundation

extension TimeInterval {
    var hourMinuteSecond: String {
        String(format: "%d:%02d:%02d", hour, minute, second)
    }
    var minuteSecond: String {
        String(format: "%d:%02d", minute, second)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
}

public func print(_ object: Any...) {
#if DEBUG
    for item in object {
        Swift.print(item)
    }
#endif
}

public func print(_ object: Any) {
#if DEBUG
    Swift.print(object)
#endif
}
