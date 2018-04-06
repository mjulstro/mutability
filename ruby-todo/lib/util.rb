class Object

  # True if the receiver is either nil or all whitespace.
  #
  # Lifed this handy method from Rails w/o requiring the whole gem.
  # https://stackoverflow.com/a/17397420/239816
  def blank?
    self !~ /[^[:space:]]/
  end

end
