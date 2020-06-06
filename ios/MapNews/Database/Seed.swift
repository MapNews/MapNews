//
//  Seed.swift
//  MapNews
//
//  Created by Hol Yin Ho on 6/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

struct Seed {
    let database: OpaquePointer?
    init(database: SQLDatabase) {
        self.database = database.database
    }

    func deleteAll() {
        let deleteAllCommand = SQLDelete(command: "DELETE FROM COUNTRIES", database: database)
        deleteAllCommand.execute()
    }

    func delete(_ command: String) {
        let deleteCommand = SQLDelete(command: command, database: database)
        deleteCommand.execute()
    }

    func insert(_ command: String) {
        let seedCommand = SQLInsert(command: command, database: database)
        seedCommand.execute()
    }
}
