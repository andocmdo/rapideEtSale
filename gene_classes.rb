###### Gene Classes ########
class SmaPercentAbove
  attr_accessor :codons
  def initialize
    # these class variables are the individual codons/parts of the gene itself
    @codons = Hash.new
    @codons["percent"] = rand       # limit for activation. are we above the x% SMA(interval)?
    @codons["interval"] = rand(200) + 1 # interval to calculate the SMA, (such as SMA(200) is 200 day moving average)
    @codons["weight"] = rand        # weight to assign this gene
  end

  def calc(record)

  end

  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @codons["percent"] = rand
    end
    if rand < rate
      @codons["interval"] = rand(200) + 1
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
    @codons["interval"] = rand(200) + 1 # how long ago to calculate the percent change from
    @codons["weight"] = rand        # weight to assign this gene
  end

  def calc(record)

  end

  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @codons["percent"] = rand
    end
    if rand < rate
      @codons["interval"] = rand(200) + 1
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
    @codons["interval"] = rand(200) + 1 # time since last buy action
    @codons["weight"] = rand        # weight to assign this gene
  end

  def calc(record)

  end

  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @codons["interval"] = rand(200) + 1
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
    @codons["interval"] = rand(200) + 1 # time since last sell action
    @codons["weight"] = rand        # weight to assign this gene
  end

  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @codons["interval"] = rand(200) + 1
    end
    if rand < rate
      @codons["weight"] = rand
    end
  end

  def calc(record)

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

  def calc(record)

  end

  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @codons["percent"] = rand
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

### This random is to be used fo testing only
class SingleRandomForTestingOnly
  attr_accessor :codons
  def initialize
    # only one random codon
    @codons = Hash.new
    @codons["weight"] = rand
  end

  def calc(record)
    # normally this would check for the activation of this scenario or trigger
    # and would then return the weight as the "points", which will later be
    # added up and normalized,
    return rand
  end

  def mutate(rate)
    # no need to mutate since it returns random
  end

  def to_string
    @codons.each do |codon_key, codon_val|
      "#{codon_key}: #{codon_val}"
    end
  end
end
