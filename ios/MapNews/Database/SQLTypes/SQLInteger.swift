//
//  SQLInteger.swift
//  MapNews
//
//  Created by Hol Yin Ho on 7/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import SQLite3

class SQLInteger: SQLType {
    var argument: Int

    required init?(argument: Any) {
        guard let int = argument as? Int else {
            return nil
        }
        self.argument = int
    }

    func bind(_ queryStatment: OpaquePointer?, index: Int32) {
        sqlite3_bind_int(queryStatment, index, Int32(argument))
    }

    static func extract(from command: SQLCommand, index: Int32) -> Int {
        let statement = command.statement
        return Int(sqlite3_column_int(statement, index))
    }
}
