require_relative "test_helper"

describe "Todo list" do

  let(:model) do
    Model.new(
      entries: [
        Entry.new(id: 10, description: "Pat head"),
        Entry.new(id: 11, description: "Rub tummy")
      ]
    )
  end

  it "starts out empty" do
    assert_equal true, Model.new.entries.empty?
    assert_equal 0, Model.new.next_id
  end

  describe Msg::UpdateNewEntryField do
    it "changes the text field in the model" do
      new_model = Engine.run(model, [
        Msg::UpdateNewEntryField.new("typing away")
      ])
      assert_equal "typing away", new_model.new_entry_field
    end
  end

  describe Msg::Add do
    it "appends a new entry" do
      new_model = Engine.run(model, [
        Msg::UpdateNewEntryField.new("hop on one foot"),
        Msg::Add.new
      ])

      assert_equal 3, new_model.entries.size
      new_entry = new_model.entries.last
      assert_equal 12, new_entry.id
      assert_equal "hop on one foot", new_entry.description
      assert_equal false, new_entry.completed
    end

    it "does nothing if the text field is blank" do
      new_model = Engine.run(model, [
        Msg::UpdateNewEntryField.new(nil),
        Msg::Add.new,
        Msg::UpdateNewEntryField.new("     "),
        Msg::Add.new
      ])

      assert_equal 2, new_model.entries.size
    end
  end

  describe Msg::Check do
    it "can check an item" do
      new_model = Engine.run(model, [
        Msg::Check.new(10, true),
      ])
      assert_equal true,  new_model.entries[0].completed
      assert_equal false, new_model.entries[1].completed
    end

    it "can uncheck an item" do
      new_model = Engine.run(model, [
        Msg::Check.new(10, true),
        Msg::Check.new(11, true),
        Msg::Check.new(10, false),
      ])
      assert_equal false, new_model.entries[0].completed
      assert_equal true,  new_model.entries[1].completed
    end
  end

  describe Msg::Delete do
    it "can delete an entry" do
      new_model = Engine.run(model, [
        Msg::Delete.new(10)
      ])
      assert_equal [11], new_model.entries.map(&:id)
    end
  end

  describe Msg::DeleteAllCompleted do
    it "" do
      new_model = Engine.run(model, [
        Msg::Check.new(10, true),
        Msg::DeleteAllCompleted.new
      ])
      assert_equal [11], new_model.entries.map(&:id)
    end
  end

  it "supports time travel" do
    # skip "Mutable model does not support time travel"

    actual_history = Engine.run_with_history(Model.new, [
      Msg::UpdateNewEntryField.new("go forward in time"),
      Msg::Add.new,
      Msg::Add.new,  # no effect
      Msg::UpdateNewEntryField.new("delete this item"),
      Msg::Add.new,
      Msg::Delete.new(2),
      Msg::UpdateNewEntryField.new("go in time"),
      Msg::UpdateNewEntryField.new("go backward in time"),
      Msg::Add.new,
      Msg::Check.new(0, true),
      Msg::Check.new(3, true),
      Msg::Check.new(3, false),
      Msg::DeleteAllCompleted.new
    ])

    expected_history = [
      Model.new(next_id: 0, new_entry_field: "go forward in time", entries: []),
      Model.new(next_id: 1, new_entry_field: "", entries: [
          Entry.new(id: 0, description: "go forward in time", completed: false)
      ]),
      Model.new(next_id: 2, new_entry_field: "", entries: [
          Entry.new(id: 0, description: "go forward in time", completed: false)
      ]),
      Model.new(next_id: 2, new_entry_field: "delete this item", entries: [
          Entry.new(id: 0, description: "go forward in time", completed: false)
      ]),
      Model.new(next_id: 3, new_entry_field: "", entries: [
          Entry.new(id: 0, description: "go forward in time", completed: false), 
          Entry.new(id: 2, description: "delete this item", completed: false)
      ]),
      Model.new(next_id: 3, new_entry_field: "", entries: [
          Entry.new(id: 0, description: "go forward in time", completed: false)
      ]),
      Model.new(next_id: 3, new_entry_field: "go in time", entries: [
          Entry.new(id: 0, description: "go forward in time", completed: false)
      ]),
      Model.new(next_id: 3, new_entry_field: "go backward in time", entries: [
          Entry.new(id: 0, description: "go forward in time", completed: false)
      ]),
      Model.new(next_id: 4, new_entry_field: "", entries: [
          Entry.new(id: 0, description: "go forward in time", completed: false), 
          Entry.new(id: 3, description: "go backward in time", completed: false)
      ]),
      Model.new(next_id: 4, new_entry_field: "", entries: [
          Entry.new(id: 0, description: "go forward in time", completed: true), 
          Entry.new(id: 3, description: "go backward in time", completed: false)
      ]),
      Model.new(next_id: 4, new_entry_field: "", entries: [
          Entry.new(id: 0, description: "go forward in time", completed: true), 
          Entry.new(id: 3, description: "go backward in time", completed: true)
      ]),
      Model.new(next_id: 4, new_entry_field: "", entries: [
          Entry.new(id: 0, description: "go forward in time", completed: true), 
          Entry.new(id: 3, description: "go backward in time", completed: false)
      ]),
      Model.new(next_id: 4, new_entry_field: "", entries: [
          Entry.new(id: 3, description: "go backward in time", completed: false)
      ]),
    ]

    # We could just do `assert_equal expected_history, actual_history`,
    # but comparing one step at a time gives more readable error messages:

    assert_equal expected_history.size, actual_history.size
    expected_history.zip(actual_history).each.with_index do |(expected, actual), index|
      assert_equal expected, actual, "History mismatch at step #{index}"
    end
  end

end
