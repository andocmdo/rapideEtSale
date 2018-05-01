###### Gene Classes ########
class SmaPercentAbove
  attr_accessor :codons
  def initialize
    # these class variables are the individual codons/parts of the gene itself
    @codons = Hash.new
    @codons["percent"] = rand       # limit for activation. are we above the x% SMA(interval)?
    @codons["interval"] = rand(200) # interval to calculate the SMA, (such as SMA(200) is 200 day moving average)
    @codons["weight"] = rand        # weight to assign this gene
  end

  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @codons["percent"] = rand
    end
    if rand < rate
      @codons["interval"] = rand(200)
    end
    if rand < rate
      @codons["weight"] = rand
    end
  end

  def to_string
    @codons.each do |codon_key, codon_val|
      "#{codon_key}: #{codon_val}"
    end
  end
end


class PercentChangePos
  attr_accessor :codons
  def initialize
    # these class variables are the individual codons/parts of the gene itself
    @codons = Hash.new
    @codons["percent"] = rand       # limit for activation. are we above the x% change (interval)?
    @codons["interval"] = rand(200) # how long ago to calculate the percent change from
    @codons["weight"] = rand        # weight to assign this gene
  end

  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @codons["percent"] = rand
    end
    if rand < rate
      @codons["interval"] = rand(200)
    end
    if rand < rate
      @codons["weight"] = rand
    end
  end

  def to_string
    @codons.each do |codon_key, codon_val|
      "#{codon_key}: #{codon_val}"
    end
  end
end


class TimeSinceLastBuy
  attr_accessor :codons
  def initialize
    # these class variables are the individual codons/parts of the gene itself
    @codons = Hash.new
    @codons["interval"] = rand(200) # time since last buy action
    @codons["weight"] = rand        # weight to assign this gene
  end

  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @codons["interval"] = rand(200)
    end
    if rand < rate
      @codons["weight"] = rand
    end
  end

  def to_string
    @codons.each do |codon_key, codon_val|
      "#{codon_key}: #{codon_val}"
    end
  end
end


class TimeSinceLastSell
  attr_accessor :codons
  def initialize
    # these class variables are the individual codons/parts of the gene itself
    @codons = Hash.new
    @codons["interval"] = rand(200) # time since last sell action
    @codons["weight"] = rand        # weight to assign this gene
  end

  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @codons["interval"] = rand(200)
    end
    if rand < rate
      @codons["weight"] = rand
    end
  end

  def to_string
    @codons.each do |codon_key, codon_val|
      "#{codon_key}: #{codon_val}"
    end
  end
end


class HaveSettledCash
  attr_accessor :codons
  def initialize
    # these class variables are the individual codons/parts of the gene itself
    @codons = Hash.new
    @codons["percent"] = rand       # limit for activation. are we above the x% SMA(interval)?
    @codons["interval"] = rand(200) # interval to calculate the SMA, (such as SMA(200) is 200 day moving average)
    @codons["weight"] = rand        # weight to assign this gene
  end

  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @codons["percent"] = rand
    end
    if rand < rate
      @codons["interval"] = rand(200)
    end
    if rand < rate
      @codons["weight"] = rand
    end
  end

  def to_string
    @codons.each do |codon_key, codon_val|
      "#{codon_key}: #{codon_val}"
    end
  end
end


class OwnStock
  # At first this is just own or not. But maybe in future we will have partial purchases...
  attr_accessor :codons
  def initialize
    # these class variables are the individual codons/parts of the gene itself
    @codons = Hash.new
    @codons["ownStock"] = false
    @codons["weight"] = rand        # weight to assign this gene
  end

  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @codons["weight"] = rand
    end
  end

  def to_string
    @codons.each do |codon_key, codon_val|
      "#{codon_key}: #{codon_val}"
    end
  end
end


class BuySellSignalsWithinPercentDiff
  attr_accessor :codons
  def initialize
    # these class variables are the individual codons/parts of the gene itself
    @codons = Hash.new
    @codons["percent"] = rand       # buy sell are within x% diff
    @codons["weight"] = rand        # weight to assign this gene
  end

  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @codons["interval"] = rand(200)
    end
    if rand < rate
      @codons["weight"] = rand
    end
  end

  def to_string
    @codons.each do |codon_key, codon_val|
      "#{codon_key}: #{codon_val}"
    end
  end
end