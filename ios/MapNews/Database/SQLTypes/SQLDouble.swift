//
//  SQLDouble.swift
//  MapNews
//
//  Created by Hol Yin Ho on 6/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import SQLite3

class SQLDouble: SQLType {
    let argument: Double

    required init?(argument: Any) {
        guard let string = argument as? Double else {
            return nil
        }
        self.argument = string
    }

    func bind(_ queryStatment: OpaquePointer?, index: Int32) {
        sqlite3_bind_double(queryStatment, index, argument)
    }

    static func extract(from command: SQLCommand, index: Int32) -> Double {
        let statement = command.statement
        return sqlite3_column_double(statement, index)
    }
}
