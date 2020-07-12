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
        let deleteAllCoordinatesCommand = SQLDelete(command: "DELETE FROM COORDINATES", database: database)
        let deleteAllNamesCommand = SQLDelete(command: "DELETE FROM NAMES", database: database)
        print("Deleting all entries...")

        deleteAllCoordinatesCommand.execute()
        deleteAllCoordinatesCommand.reset()
        deleteAllCoordinatesCommand.tearDown()

        deleteAllNamesCommand.execute()
        deleteAllNamesCommand.reset()
        deleteAllNamesCommand.tearDown()
    }

    func delete(_ command: String) {
        let deleteCommand = SQLDelete(command: command, database: database)
        deleteCommand.execute()
        deleteCommand.reset()
        deleteCommand.tearDown()
    }

    func insert(_ command: String) {
        let seedCommand = SQLInsert(command: command, database: database)
        seedCommand.execute()
        seedCommand.reset()
        seedCommand.tearDown()
    }
}
