import XCTest
@testable import Todo

class TodoTests: XCTestCase {
    var model = Model(
        entries: [
            Entry(id: 10, description: "Pat head"),
            Entry(id: 11, description: "Rub tummy")
        ]
    )

    func testModelStartsEmpty() {
        XCTAssertEqual(true, Model().entries.isEmpty)
        XCTAssertEqual(0, Model().nextID)
    }

     func testUpdateNewEntryField() {
         let newModel = Engine.run(on: model, applying: [
             .updateNewEntryField("typing away")
         ])
         XCTAssertEqual("typing away", newModel.newEntryField)
     }

     func testAdd() {
         let newModel = Engine.run(on: model, applying: [
             .updateNewEntryField("hop on one foot"),
             .add
         ])
         XCTAssertEqual(3, newModel.entries.count)
         let newEntry = newModel.entries.last!
         XCTAssertEqual(12, newEntry.id)
         XCTAssertEqual("hop on one foot", newEntry.description)
         XCTAssertEqual(false, newEntry.completed)
     }

     func testAddDoesNothingIfFieldIsBlank() {
         let newModel = Engine.run(on: model, applying: [
             .updateNewEntryField(""),
             .add,
             .updateNewEntryField("     "),
             .add
         ])

         XCTAssertEqual(2, newModel.entries.count)
     }

     func testCheck() {
         let newModel = Engine.run(on: model, applying: [
             .check(10, true),
         ])
         XCTAssertEqual(true,  newModel.entries[0].completed)
         XCTAssertEqual(false, newModel.entries[1].completed)
     }

     func testUncheck() {
         let newModel = Engine.run(on: model, applying: [
             .check(10, true),
             .check(11, true),
             .check(10, false),
         ])
         XCTAssertEqual(false, newModel.entries[0].completed)
         XCTAssertEqual(true,  newModel.entries[1].completed)
     }

     func testDelete() {
         let newModel = Engine.run(on: model, applying: [
             .delete(10)
         ])
         XCTAssertEqual([11], newModel.entries.map { $0.id })
     }

     func testDeleteAllCompleted() {
         let newModel = Engine.run(on: model, applying: [
             .check(10, true),
             .deleteAllCompleted
         ])
         XCTAssertEqual([11], newModel.entries.map { $0.id })
     }


     func testTimeTravel() {
        let actualHistory = Engine.runWithHistory(on: Model(), applying: [
             .updateNewEntryField("go forward in time"),
             .add,
             .add,  // no effect
             .updateNewEntryField("delete this item"),
             .add,
             .delete(2),
             .updateNewEntryField("go in time"),
             .updateNewEntryField("go backward in time"),
             .add,
             .check(0, true),
             .check(3, true),
             .check(3, false),
             .deleteAllCompleted
         ])

         let expectedHistory = [
             Model(nextID: 0, newEntryField: "go forward in time", entries: []),
             Model(nextID: 1, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false)
             ]),
             Model(nextID: 2, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false)
             ]),
             Model(nextID: 2, newEntryField: "delete this item", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false)
             ]),
             Model(nextID: 3, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false),
                 Entry(id: 2, description: "delete this item", completed: false)
             ]),
             Model(nextID: 3, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false)
             ]),
             Model(nextID: 3, newEntryField: "go in time", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false)
             ]),
             Model(nextID: 3, newEntryField: "go backward in time", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false)
             ]),
             Model(nextID: 4, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false),
                 Entry(id: 3, description: "go backward in time", completed: false)
             ]),
             Model(nextID: 4, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: true),
                 Entry(id: 3, description: "go backward in time", completed: false)
             ]),
             Model(nextID: 4, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: true),
                 Entry(id: 3, description: "go backward in time", completed: true)
             ]),
             Model(nextID: 4, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: true),
                 Entry(id: 3, description: "go backward in time", completed: false)
             ]),
             Model(nextID: 4, newEntryField: "", entries: [
                 Entry(id: 3, description: "go backward in time", completed: false)
             ]),
         ]

         XCTAssertEqual(expectedHistory.count, actualHistory.count)
         for (index, (expected, actual)) in zip(expectedHistory, actualHistory).enumerated() {
             XCTAssertEqual(expected, actual, "History mismatch at step \(index)")
         }
    }

}
