module Msg

  class Add
    def apply_to(model)
      unless model.new_entry_field.blank?
        model.entries << Entry.new(
          description: model.new_entry_field,
          id: model.next_id)
      end
      model.next_id += 1
      model.new_entry_field = ""
    end
  end

  class UpdateNewEntryField
    def initialize(str)
      @str = str
    end

    attr_reader :str 

    def apply_to(model)
      model.new_entry_field = str
    end
  end

  class Check
    def initialize(id, is_completed)
      @id, @is_completed = id, is_completed
    end

    attr_reader :id, :is_completed 

    def apply_to(model)
      model.entries.each do |entry|
        if entry.id == id
          entry.completed = is_completed
        end
      end
    end
  end

  class Delete
    def initialize(id)
      @id = id
    end

    attr_reader :id 

    def apply_to(model)
      model.entries.reject! { |e| e.id == id }
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      model.entries.reject!(&:completed)
    end
  end

end
