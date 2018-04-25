# Remember: Quick and Dirty this time...
require 'json'

class Agent
  def initialize(conf)
    # make our genome arrays
    buy_genes = Array.new
    sell_genes = Array.new
    hold_genes = Array.new

    # pull in the startingCash amount
    starting_cash = conf["agent"]["startingCash"]

    # Now load in the appropriate files/classes for genome
    conf["agent"]["buyGenes"].each do |classname|
      buy_genes << Object.const_get(classname).new #does init work???
    end
    conf["agent"]["sellGenes"].each do |filename|
      sell_genes << Object.const_get(classname).new
    end
    conf["agent"]["holdGenes"].each do |filename|
      hold_genes << Object.const_get(classname).new
    end
  # init end
  end
# class end
end

class SmaPercentAbove
end
class PercentChangePos
end
class TimeSinceLastBuy
end
class TimeSinceLastSell
end
class HaveSettledCash
end
class OwnStock
end
class BuySellSignalsClose
end


####################### Script runs below here ################
# load configuration
if ARGV[0] != nil && ARGV[0].start_with?("{")
  config = JSON.parse(ARGV[0])
else
  puts "Missing configuration argument. Need JSON string!"
end

# create the population
population = Array.new
(0..config["ga"]["populationSize"]).each do |_|
  population << Agent.new(config)
end
puts population
