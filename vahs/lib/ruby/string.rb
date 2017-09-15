class String
  def scramble64 seed: nil
    seed = Random.new(seed) if seed.present?
    seed ||= Random.new

    [ chars.shuffle(random: seed).join('') ].pack('m')
  end

  def unscramble64 seed: nil
    seed = Random.new(seed) if seed.present?
    seed ||= Random.new

    unpack('m').first.chars.unshuffle(random: seed).join('')
  end

  def rotate
    tr 'A-Za-z0-9', 'N-ZA-Mn-za-m5-90-4'
  end
end
