//
//  BetTests.swift
//  BetTests
//
//  Created by Maxime de Chalendar on 01/10/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import XCTest

// Tests are ran using the en_US locale

class BetTests: XCTestCase {

    let formatter = DurationFormatter.shared

    func testZero() {
        XCTAssertEqual(formatter.string(from: -100), "--")
        XCTAssertEqual(formatter.string(from: -1), "--")
        XCTAssertEqual(formatter.string(from: 0), "--")
    }

    func testSecondsDuration() {
        XCTAssertEqual(formatter.string(from: 1), "00:00:01")
        XCTAssertEqual(formatter.string(from: 40), "00:00:40")
        XCTAssertEqual(formatter.string(from: 59), "00:00:59")
    }

    func testMinutesDuration() {
        XCTAssertEqual(formatter.string(from: 60), "00:01:00")
        XCTAssertEqual(formatter.string(from: 1320), "00:22:00")
        XCTAssertEqual(formatter.string(from: 3540), "00:59:00")
    }

    func testHoursDuration() {
        XCTAssertEqual(formatter.string(from: 3600), "1:00:00")
        XCTAssertEqual(formatter.string(from: 28800), "8:00:00")
        XCTAssertEqual(formatter.string(from: 86400), "24:00:00")
        XCTAssertEqual(formatter.string(from: 172800), "48:00:00")
    }

    func testMinutesSecondsDuration() {
        XCTAssertEqual(formatter.string(from: 61), "00:01:01")
        XCTAssertEqual(formatter.string(from: 1234), "00:20:34")
        XCTAssertEqual(formatter.string(from: 3599), "00:59:59")
    }

    func testHoursMinutesDuration() {
        XCTAssertEqual(formatter.string(from: 3660), "1:01:00")
        XCTAssertEqual(formatter.string(from: 4920), "1:22:00")
        XCTAssertEqual(formatter.string(from: 7140), "1:59:00")
    }

    func testHoursMinutesSecondsDuration() {
        XCTAssertEqual(formatter.string(from: 3661), "1:01:01")
        XCTAssertEqual(formatter.string(from: 4025), "1:07:05")
        XCTAssertEqual(formatter.string(from: 7199), "1:59:59")
    }

}
