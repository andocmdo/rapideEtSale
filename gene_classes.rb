###### Gene Classes ########
class SmaPercent
  attr_accessor :codons
  def initialize
    # these class variables are the individual codons/parts of the gene itself
    @codons = Hash.new
    @codons["percent"] = (rand * 2.0) - 1.0       # limit for activation. are we above the x% SMA(interval)?
    # TODO make this interval limit configurable
    @codons["interval"] = rand(200) + 1 # interval to calculate the SMA, (such as SMA(200) is 200 day moving average)
    @codons["above"] = [true, false].sample  # true is above x%, false is below
    @codons["weight"] = rand        # weight to assign this gene
  end


  # at first I was thinking that I could add methods needed for the calculations
  # for each gene here dynamically, but now I'm thinking I will add it to the record
  # class anyways...
  def calc(record, current_index)
    # if method doesn't exist, add it
    if !record.respond_to?("sma")
      # open the class again and insert the method
      class Record
        def sma(interval)
          if interval == 0
            sma_for_interval = avgOHLC
          elsif @data["sma"].key?(interval) # if it's already been computed
            return @data["sma"][interval]   # return precomputed value
          else
            # calculate it
            # if the reqested interval is too far behind our list of records
            # then limit it to the maximum length from our current record index
            index = $records.index(this)
            if index < interval
              interval = index
            end
            # here is the calculation part
            sum = 0.0
            (0..interval).each do |i|
              sum += $records[index - i].avgOHLC
            end
            return sum / interval
          end
        end # end of sma method
      end # end of class insertion
    end # end of method check

    # now since we know the record responds to the required methods, we calc the
    # activation for this gene
    # right now it's either activated or not, (on/off), maybe in future we can
    # return adjusted values according to some activation function (sigmoid?)
    # for how close it is within it's desired bounds.
    current_percent_from_sma = (record.avgOHLC / record.sma(interval)) - 1.0
    if @codons["above"]   # if we are checking for above
      if current_percent_from_sma > @codons["percent"]
        return @codons["weight"]
      end
    else
      if current_percent_from_sma < @codons["percent"]
        return @codons["weight"]
      end
    end 
  end # end of calc method

  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @codons["percent"] = (rand * 2.0) - 1.0
    end
    if rand < rate
      @codons["interval"] = rand(200) + 1
    end
    if rand < rate
      @codons["over_under"] = [true, false].sample
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
