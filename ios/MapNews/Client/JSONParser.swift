//
//  JSONParser.swift
//  MapNews
//
//  Created by Hol Yin Ho on 7/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

struct JSONParser {
    static func getObject(from jsonObject: Any, key: String) -> Any? {
        guard let object = jsonObject as? [String: Any] else {
            return nil
        }
        return object[key]
    }
}
