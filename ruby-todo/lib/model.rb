class Model
  def initialize(entries: [], new_entry_field: "", next_id: nil)
    @entries, @new_entry_field = entries, new_entry_field
    @next_id = next_id ||
      (entries.lazy.map(&:id).max || -1) + 1
  end

  attr_accessor :entries, :new_entry_field, :next_id

  def ==(other)
    !other.nil? &&
      self.new_entry_field == other.new_entry_field &&
      self.next_id == other.next_id &&
      self.entries == other.entries
  end
end

class Entry
  def initialize(id:, description:, completed: false)
    @description, @id, @completed = description, id, completed
  end

  attr_accessor :description, :completed, :id

  def ==(other)
    !other.nil? &&
      self.id == other.id &&
      self.description == other.description &&
      self.completed == other.completed
  end
end
