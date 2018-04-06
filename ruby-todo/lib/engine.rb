module Engine
  def self.run(*args)
    run_with_history(*args).last
  end

  def self.run_with_history(model, messages)
    messages.map do |msg|
      msg.apply_to(model)
      model
    end
  end
end
