//
//  JSONParser.swift
//  MapNews
//
//  Created by Hol Yin Ho on 7/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import Foundation

struct JSONParser {
    static func createJsonObject(from data: Data) -> Any? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return jsonObject
        } catch {
            print("Unable to create json object")
            return nil
        }
    }

    static func getObject(from jsonObject: Any, key: String) -> Any? {
        guard let object = jsonObject as? [String: Any] else {
            return nil
        }
        return object[key]
    }

    static func getArray(from jsonObject: Any, key: String) -> Array<Any>? {
        return getObject(from: jsonObject, key: key) as? Array<Any>
    }
}
