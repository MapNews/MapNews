//
//  SQLString.swift
//  MapNews
//
//  Created by Hol Yin Ho on 6/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import SQLite3

class SQLString: SQLType {
    let argument: String

    required init?(argument: Any) {
        guard let string = argument as? String else {
            return nil
        }
        self.argument = string
    }

    func bind(_ queryStatment: OpaquePointer?, index: Int32) {
        sqlite3_bind_text(queryStatment, index, argument, -1, nil)
    }

    static func extract(from command: SQLCommand, index: Int32) -> String {
        let statement = command.statement
        return String(cString: sqlite3_column_text(statement, index))
    }
}
