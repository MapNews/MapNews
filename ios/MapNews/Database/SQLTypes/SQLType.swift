//
//  SQLType.swift
//  MapNews
//
//  Created by Hol Yin Ho on 6/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

protocol SQLType {
    init?(argument: Any)

    // Index is 1 base
    func bind(_ queryStatment: OpaquePointer?, index: Int32)
}
