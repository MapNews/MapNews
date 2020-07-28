//
//  RequestBuilder.swift
//  MapNews
//
//  Created by Hol Yin Ho on 27/7/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

class RequestBuilder {
    let baseUrl: String
    let params: [(String, String)]

    init(baseUrl: String) {
        self.baseUrl = baseUrl
        self.params = []
    }

    init(baseUrl: String, params: [(String, String)]) {
        self.baseUrl = baseUrl
        self.params = params
    }

    func addParam(param: String, value: String) -> RequestBuilder {
        var newParams = params
        newParams.append((param, value))
        return RequestBuilder(baseUrl: baseUrl, params: newParams)
    }

    func build() -> String {
        let paramSubstrings = params.reduce("", { $0 + "&" + $1.0 + "=" + $1.1 }).dropFirst()
        let paramStrings = String(paramSubstrings)
        return baseUrl + paramStrings
    }
}
