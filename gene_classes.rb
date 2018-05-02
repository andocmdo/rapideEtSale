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
    sma_for_interval = 0.0
    if !record.data.key?("sma")     # if it doesn't yet exists in the records hash
      record.data["sma"] = Hash.new # put it in there
    end
    if record.data["sma"].key?(@codons["interval"])   # then if we already have a value for that interval
      sma_for_interval = record.data["sma"][@codons["interval"]]  # then get it
    else
      sum = 0.0
      #TODO this will never work, since we will likely need to rely on the order for which these
      # items are computed. For instance, if this requires the use of avgOHLC, then before using it
      # we are going to need to be sure it's been computed... hmmmm
      # might need to track dependencies...
    end
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
