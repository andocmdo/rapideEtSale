###### Gene Classes ########
class SmaPercentAbove
  def initialize
    # these class variables are the individual codons/parts of the gene itself
    @percent = rand       # limit for activation. are we above the x% SMA(interval)?
    @interval = rand(200) # interval to calculate the SMA, (such as SMA(200) is 200 day moving average)
    @weight = rand        # weight to assign this gene
  end
  def mutate(rate)        # We mutate each gene component individually
    if rand < rate
      @percent = rand
    end
    if rand < rate
      @interval = rand(200)
    end
    if rand < rate
      @weight = rand
    end
  end
  def to_string
    "percent=#{@percent.round(3)} interval=#{@interval} weight=#{@weight.round(3)} "
  end
end

class PercentChangePos
  def to_string
    "blah "
  end
end

class TimeSinceLastBuy
  def to_string
    "blah "
  end
end

class TimeSinceLastSell
  def to_string
    "blah "
  end
end

class HaveSettledCash
  def to_string
    "blah "
  end
end

class OwnStock
  def to_string
    "blah "
  end
end

class BuySellSignalsClose
  def to_string
    "blah "
  end
end
