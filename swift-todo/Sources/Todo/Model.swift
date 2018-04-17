struct Model {
    var entries: [Entry]
    var newEntryField: String
    var nextID: Int

    init(nextID: Int? = nil, newEntryField: String = "", entries: [Entry] = []) {
        self.entries = entries
        self.newEntryField = newEntryField
        self.nextID = nextID ??
            (entries.map { $0.id }.max() ?? -1) + 1
    }
}

struct Entry {
    var id: Int
    var description: String
    var completed: Bool

    init(id: Int, description: String, completed: Bool = false) {
        self.id = id
        self.description = description
        self.completed = completed
    }
}

extension Model: Equatable {
    static func == (lhs: Model, rhs: Model) -> Bool {
        return lhs.newEntryField == rhs.newEntryField
            && lhs.nextID == rhs.nextID
            && lhs.entries == rhs.entries
    }
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.id == rhs.id
            && lhs.description == rhs.description
            && lhs.completed == rhs.completed
    }
}
