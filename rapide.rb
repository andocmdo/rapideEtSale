##### Remember: Quick and Dirty this time...
require 'json'

# General Classes
class Agent
  attr_accessor :buy_genes, :sell_genes, :hold_genes, :starting_cash
  attr_reader :fitness
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

  def calc_fitness
    #TODO fix this
    return rand.round(3)
  end

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


class High_Scores_and_Stats
  attr_accessor :num_high_scores
  attr_reader :high_score_agents, :min_high_score
  # TODO add hashes for storing each generations max/min/avg/stdev/etc
  def initialize(num_high_scores=10)
    @num_high_scores = num_high_scores  # number of top scoring agents to keep
    @high_score_agents = Array.new      # sorted array of top scoring agents
    @min_high_score = 0.0               # the minimum score in high_score_agents
  end

  def feed(scores, population)
    scores.each do |index, score|
      # TODO add avg/max/min/stdev for all scores for each generation
      # for each agent at index with some score, check if it is high enough
      # to enter into the high score agents list.
      if score > @min_high_score
        add_high_score_agent(population[index])
      end
    end
  end

  def add_high_score_agent(agent)
    if @high_score_agents.empty?  # if this is the first entry, nothing to compare to
      @high_score_agents << agent
    else
      @high_score_agents.each_with_index do |high_score_agent, index|
        if agent.fitness > high_score_agent.fitness
          @high_score_agents.insert(index, agent)
          # TODO someday we should check that an equal scoring, but genetically
          # different (although same exact action log) agent can be added without
          # being discarded because the score was the same as another "first-come"
          # Agent already on the high scores list...
          
          # now remove the @num_high_scores + 1 item to keep us in limits
          if @high_score_agents.size > @num_high_scores
            @high_score_agents.pop
          end
      end
    end # if/else end
  end # add_high_score_agent end
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
stats = High_Scores_and_Stats.new(config["ga"]["numberOfHighScores"])

# run the steps for the Genetic Algorithm
(0...max_generations).each do |generation|
  # run agents through sim and calculate fitness
  # keep a hash of index in population and score
  scores = Hash.new
  population.each_with_index do |agent, index|
    scores[index] = agent.calc_fitness
  end
  # feed that hash info to the stats tracker, who will then pull back out
  # the agents that have top scores
  stats.feed(scores, population)


  # xover

  # mutate
end
