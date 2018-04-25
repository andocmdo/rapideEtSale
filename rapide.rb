# Remember: Quick and Dirty this time...
require 'json'

class Agent
  attr_accessor :buy_genes, :sell_genes, :hold_genes

  def initialize(conf)
    # make our genome arrays
    @buy_genes = Array.new
    @sell_genes = Array.new
    @hold_genes = Array.new

    # pull in the startingCash amount
    starting_cash = conf["agent"]["startingCash"]

    # Now load in the appropriate files/classes for genome
    conf["agent"]["buyGenes"].each do |gene_class|
      @buy_genes << Object.const_get(gene_class).new #does init work???
    end
    conf["agent"]["sellGenes"].each do |gene_class|
      @sell_genes << Object.const_get(gene_class).new
    end
    conf["agent"]["holdGenes"].each do |gene_class|
      @hold_genes << Object.const_get(gene_class).new
    end
  end # init end

  def genes_to_string
    result = "buy genes:"
    @buy_genes.each do |gene|
      result = "#{result} #{gene.class.name}"
    end
    result = "#{result}\nsell genes:"
    @sell_genes.each do |gene|
      result = "#{result} #{gene.class.name}"
    end
    result = "#{result}\nhold genes:"
    @hold_genes.each do |gene|
      result = "#{result} #{gene.class.name}"
    end
    return result
  end
end # class end

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
(0...config["ga"]["populationSize"]).each do |_|
  population << Agent.new(config)
end

population.each do |agent|
  puts agent.genes_to_string
end

# set the population parameters
mutation_rate = config["ga"]["mutationRate"]
xover_pool_size_ratio = config["ga"]["xoverPoolSizeRatio"]
