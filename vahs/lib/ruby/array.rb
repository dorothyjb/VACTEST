class Array
  # shamefully yanked from the internet somewhere
  def unshuffle random:
    transformed_order = (0...length).to_a.shuffle!(random: random)
    sort_by.with_index { |_, i| transformed_order[i] }
  end
end
