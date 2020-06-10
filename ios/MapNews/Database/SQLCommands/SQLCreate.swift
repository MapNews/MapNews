//
//  SQLCreate.swift
//  MapNews
//
//  Created by Hol Yin Ho on 6/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import SQLite3

class SQLCreate: SQLCommand {
    var statement: OpaquePointer?
    var isNullable = false

    required init(command: String, database: OpaquePointer?) {
        if sqlite3_prepare_v2(database, command, -1, &statement, nil) != SQLITE_OK {
            print("CREATE statement is not prepared")
            return
        }
    }

    func execute() {
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Table was not created")
            isNullable = true
            return
        }
    }
}
