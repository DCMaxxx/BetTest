//
//  DurationFormatter.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 01/10/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import Foundation

/// A class that transforms a duration into human-readable string
final class DurationFormatter {

    static let shared = DurationFormatter()

    private lazy var internalFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    private init() {

    }

    func string(from duration: TimeInterval) -> String {
        guard let formattedDuration = internalFormatter.string(from: duration) else {
            let seconds = Int(duration)
            return L10n.Durationformatter.secondsFallback(seconds)
        }
        return formattedDuration
    }

}
