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
        XCTAssertEqual(formatter.string(from: 1), "1s")
        XCTAssertEqual(formatter.string(from: 40), "40s")
        XCTAssertEqual(formatter.string(from: 59), "59s")
    }

    func testMinutesDuration() {
        XCTAssertEqual(formatter.string(from: 60), "1m")
        XCTAssertEqual(formatter.string(from: 1320), "22m")
        XCTAssertEqual(formatter.string(from: 3540), "59m")
    }

    func testHoursDuration() {
        XCTAssertEqual(formatter.string(from: 3600), "1h")
        XCTAssertEqual(formatter.string(from: 28800), "8h")
        XCTAssertEqual(formatter.string(from: 86400), "24h")
        XCTAssertEqual(formatter.string(from: 172800), "48h")
    }

    func testMinutesSecondsDuration() {
        XCTAssertEqual(formatter.string(from: 61), "1m 1s")
        XCTAssertEqual(formatter.string(from: 1234), "20m 34s")
        XCTAssertEqual(formatter.string(from: 3599), "59m 59s")
    }

    func testHoursMinutesDuration() {
        XCTAssertEqual(formatter.string(from: 3660), "1h 1m")
        XCTAssertEqual(formatter.string(from: 4920), "1h 22m")
        XCTAssertEqual(formatter.string(from: 7140), "1h 59m")
    }

    func testHoursMinutesSecondsDuration() {
        XCTAssertEqual(formatter.string(from: 3661), "1h 1m 1s")
        XCTAssertEqual(formatter.string(from: 4025), "1h 7m 5s")
        XCTAssertEqual(formatter.string(from: 7199), "1h 59m 59s")
    }

}
