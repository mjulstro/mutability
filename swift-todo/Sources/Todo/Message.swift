//
//  Messages.swift
//  Todo
//
//  Created by Paul on 2018/4/4.
//

import Foundation

enum Message {
    case add
    case updateNewEntryField(String)
    case check(Int, Bool)
    case delete(Int)
    case deleteAllCompleted

    func apply(to model: Model) -> Model {
        var new_entries = model.entries
        var new_newEntryField = model.newEntryField
        var new_nextID = model.nextID
        switch(self) {
            case .add:
                if !model.newEntryField.isBlank() {
                    new_entries.append(Entry(id: model.nextID, description: model.newEntryField))
                }
                new_nextID += 1
                new_newEntryField = ""

            case .updateNewEntryField(let str):
                new_newEntryField = str

            case .check(let id, let isCompleted):
                new_entries = []
                for entry in model.entries {
                    if(entry.id == id) {
                        new_entries.append(Entry(id: entry.id,
                            description: entry.description,
                            completed: isCompleted))
                    }
                }

            case .delete(let id):
                new_entries.remove { $0.id == id }

            case .deleteAllCompleted:
                new_entries.remove { $0.completed }
        }
        return Model(nextID: new_nextID,
                     newEntryField: new_newEntryField,
                     entries: new_entries)
    }
}
