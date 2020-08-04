//
//  TimeUtil.swift
//  MapNews
//
//  Created by Hol Yin Ho on 2/8/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import Foundation

struct TimeUtil {
    static let DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    private static let SECONDS_IN_DAY: Double = 86400
    private static let SECONDS_IN_HOUR: Double = 3600
    private static let SECONDS_IN_MIN: Double = 60

    static func dateToTimeDisplayString(date: Date?) -> String {
        guard let dateObj = date else {
            return ""
        }
        let publishedInterval = dateObj.distance(to: Date())
        if publishedInterval < SECONDS_IN_HOUR {
            let minutesAgo = Int(floor(publishedInterval / SECONDS_IN_MIN))
            let unit = minutesAgo == 1 ? "min" : "mins"
            return "\(minutesAgo) \(unit) ago"
        } else if publishedInterval < SECONDS_IN_DAY {
            let hoursAgo = Int(floor(publishedInterval / SECONDS_IN_HOUR))
            let unit = hoursAgo == 1 ? "hour" : "hours"
            return "\(hoursAgo) \(unit) ago"
        } else {
            let daysAgo = Int(floor(publishedInterval / SECONDS_IN_DAY))
            let unit = daysAgo == 1 ? "day" : "days"
            return "\(daysAgo) \(unit) ago"
        }
    }

    static func toDate(_ string: String) -> Date? {
        if string.count < 20 {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = DATE_FORMAT
        return formatter.date(from: string)
    }
}
