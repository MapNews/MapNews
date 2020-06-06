//
//  SQLCommand.swift
//  MapNews
//
//  Created by Hol Yin Ho on 6/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import SQLite3

protocol SQLCommand {
    var statement: OpaquePointer? { get }
    var isNullable: Bool { get }

    init(command: String, database: OpaquePointer?)

    func execute()
}

extension SQLCommand {
    func with(argument: SQLType, index: Int32) -> SQLCommand {
        argument.bind(statement, index: index)
        return self
    }

    func tearDown() {
        sqlite3_finalize(statement)
    }

    func reset() {
        sqlite3_reset(statement)
    }
}
