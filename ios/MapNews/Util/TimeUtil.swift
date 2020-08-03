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

    static func dateToTimeDisplayString(date: Date?) -> String {
        guard let dateObj = date else {
            return ""
        }
        let dayInterval: Double = 86400
        let hourInterval: Double = 3600
        let minInterval: Double = 60
        let publishedInterval = dateObj.distance(to: Date())
        if publishedInterval < hourInterval {
            let minutesAgo = Int(floor(publishedInterval / minInterval))
            let unit = minutesAgo == 1 ? "min" : "mins"
            return "\(minutesAgo) \(unit) ago"
        } else if publishedInterval < dayInterval {
            let hoursAgo = Int(floor(publishedInterval / hourInterval))
            let unit = hoursAgo == 1 ? "hour" : "hours"
            return "\(hoursAgo) \(unit) ago"
        } else {
            let daysAgo = Int(floor(publishedInterval / dayInterval))
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
