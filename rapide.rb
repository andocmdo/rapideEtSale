##### Remember: Quick and Dirty this time...
require 'json'


class Agent
  attr_accessor :buy_genes, :sell_genes, :hold_genes, :starting_cash

  def initialize(conf)
    # make our genome arrays
    @buy_genes = Array.new
    @sell_genes = Array.new
    @hold_genes = Array.new

    # pull in the startingCash amount
    @starting_cash = conf["agent"]["startingCash"]

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
      result = "#{result} #{gene.class.name}: #{gene.to_string}"
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


####################### Script runs below here ################
# load configuration
if ARGV[0] != nil && ARGV[0].start_with?("{")
  config = JSON.parse(ARGV[0])
else
  puts "Missing configuration argument. Need JSON string!"
end

# create the population
population = Array.new
(0...config["ga"]["populationSize"]).each do
  population << Agent.new(config)
end

# DEBUG remove later
population.each do |agent|
  puts agent.genes_to_string
end

# set the population parameters
mutation_rate = config["ga"]["mutationRate"]
xover_pool_size_ratio = config["ga"]["xoverPoolSizeRatio"]
max_generations = config["ga"]["maxGenerations"]

# initialize the High Scores and Stats recordkeeper


# run the steps for the Genetic Algorithm
(0...max_generations).each do |generation|
  # run agents through sim and calculate fitness
  population.each do |agent|
    agent.calculate_fitness()
  end

  # xover

  # mutate
end
