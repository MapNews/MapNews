//
//  TimeUtilTests.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 2/8/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import XCTest

class TimeUtilTests: XCTestCase {
    var now: Date!

    override func setUp() {
        now = Date()
    }

    func testDateToTimeDisplayString_dateIsNil_returnEmptyString() {
        XCTAssertTrue(TimeUtil.dateToTimeDisplayString(date: nil).isEmpty)
    }

    func testDateToTimeDisplayString_dateIs1MinAgo_returnsFormattedDisplayString() {
        let sixtySecondsEarlier = now.addingTimeInterval(-60)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: sixtySecondsEarlier), "1 min ago")
        let seventySecondsEarlier = now.addingTimeInterval(-70)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: seventySecondsEarlier), "1 min ago")
        let hundredAndNineteenSecondsEarlier = now.addingTimeInterval(-119)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: hundredAndNineteenSecondsEarlier), "1 min ago")
    }

    func testDateToTimeDisplayString_dateIsLessThan1HourAgo_returnsFormattedDisplayString() {
        let time1 = now.addingTimeInterval(-120)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time1), "2 mins ago")
        let time2 = now.addingTimeInterval(-361)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time2), "6 mins ago")
        let time3 = now.addingTimeInterval(-3599)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time3), "59 mins ago")
    }

    func testDateToTimeDisplayString_dateIs1hourAgo_returnsFormattedDisplayString() {
        let time1 = now.addingTimeInterval(-3600)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time1), "1 hour ago")
        let time2 = now.addingTimeInterval(-5234)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time2), "1 hour ago")
        let time3 = now.addingTimeInterval(-7199)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time3), "1 hour ago")
    }

    func testDateToTimeDisplayString_dateIsLessThan1DayAgo_returnsFormattedDisplayString() {
        let time1 = now.addingTimeInterval(-7200)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time1), "2 hours ago")
        let time2 = now.addingTimeInterval(-79205)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time2), "22 hours ago")
        let time3 = now.addingTimeInterval(-86399)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time3), "23 hours ago")
    }

    func testDateToTimeDisplayString_dateIs1DayAgo_returnsFormattedDisplayString() {
        let time1 = now.addingTimeInterval(-86400)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time1), "1 day ago")
        let time2 = now.addingTimeInterval(-129602)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time2), "1 day ago")
        let time3 = now.addingTimeInterval(-172799)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time3), "1 day ago")
    }

    func testDateToTimeDisplayString_dateIsMoreThan1DayAgo_returnsFormattedDisplayString() {
        let time1 = now.addingTimeInterval(-172800)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time1), "2 days ago")
        let time2 = now.addingTimeInterval(-200000)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time2), "2 days ago")
        let time3 = now.addingTimeInterval(-345601)
        XCTAssertEqual(TimeUtil.dateToTimeDisplayString(date: time3), "4 days ago")
    }

    func testToDate_stringTooShort_returnNil() {
        XCTAssertNil(TimeUtil.toDate("iAmTooShort"))
    }

    func testToDate_invalidString_returnNil() {
        XCTAssertNil(TimeUtil.toDate("iAmLongEnoughButInvalid"))
    }

    func testToDate_validString_returnsOptionalDate() {
        guard let date = TimeUtil.toDate("1970-01-01T00:27:15Z") else {
            XCTFail("Date should be able to be created")
            return
        }
        XCTAssertEqual(Int(date.timeIntervalSince1970), 1635)
    }
}
