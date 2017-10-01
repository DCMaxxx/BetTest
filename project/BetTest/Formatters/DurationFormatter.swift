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
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .positional
        return formatter
    }()

    private init() {

    }

    func string(from duration: TimeInterval) -> String {
        guard duration > 0 else {
            return L10n.Durationformatter.zero
        }

        guard let formattedDuration = internalFormatter.string(from: duration) else {
            let seconds = Int(duration)
            return L10n.Durationformatter.secondsFallback(seconds)
        }

        // WORKAROUND:
        // This shouldn't have to be done, but there is a bug on Apple's side
        // regarding the behavior of DateComponentsFormatter.ZeroFormattingBehavior.pad
        // It pads correctly for minutes and seconds, but not for hours.
        // Apple's own example is :
        // Off: "1:0:10", On: "01:00:10"
        // The actual behavior is:
        // Off: "1:0:10", On: "1:00:10"
        // As the requirement explicitly states that hours should be at least two digits,
        // I have to add some ugly code, that adds a zero if Apple forgets it.
        if formattedDuration.hasPrefix("0:") {
            return "0" + formattedDuration
        }

        return formattedDuration
    }

}
