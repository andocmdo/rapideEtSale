##### Remember: Quick and Dirty this time...
require 'json'
#require 'descriptive_statistics'

require_relative 'agent'
require_relative 'high_scores_and_stats'
require_relative 'record'
require_relative 'gene_classes'



####################### Script runs below here ################
# load configuration
if ARGV[0] != nil && ARGV[0].start_with?("{")
  config = JSON.parse(ARGV[0])
else
  puts "Missing configuration argument. Need JSON string!"
end

# load the records for the simulation
# TODO make this a singleton or something, this is trashy
$records = Record.load_records(config)

# create the population
population_size = config["ga"]["populationSize"]
population = Array.new
(0...population_size).each do
  population << Agent.new(config)
end

# set the population parameters
mutation_rate = config["ga"]["mutationRate"]
xover_pool_size_ratio = config["ga"]["xoverPoolSizeRatio"]
max_generations = config["ga"]["maxGenerations"]

# initialize the High Scores and Stats recordkeeper
# TODO send just the config, so that we can add more options later
stats = High_Scores_and_Stats.new(config["ga"]["numberOfHighScores"])

# run the steps for the Genetic Algorithm
(0...max_generations).each do |generation|
  puts "\nGeneration: #{generation}"    # TODO remove for debug

  # run agents through sim and calculate fitness
  scores = Array.new
  population.each do |agent|
    agent.run_sim($records)    # run the agent through the simulation first
    scores << agent.fitness   # then get the fitness
  end
  # feed that info to the stats tracker, who will then pull back out
  # the agents that have top scores
  stats.feed(scores, population)
  stats.print_high_scores

  # xover
  xover_pool = Array.new
  population.each do |agent|
    # add n number of agent copies to the mating pool according to xover_pool_size_ratio
    # and always add at least 1 no matter what (everyone gets a chance)
    (0...((agent.fitness * xover_pool_size_ratio).to_i + 1)).each do
      xover_pool << agent
    end
  end # xover pool filling loop end
  #puts xover_pool.size

  # clear out the old population array, get ready to add children from xover pool
  population = Array.new
  (0...population_size).each do
    parentA = xover_pool[rand(xover_pool.size)]
    parentB = nil
    loop do
      parentB = xover_pool[rand(xover_pool.size)]
      break if !parentA.equal?(parentB)   # don't allow agent to xover with itself
    end
    population << parentA.xover(parentB)
  end # crossover loop

  # mutate
  population.each do |agent|
    agent.mutate(mutation_rate)
  end # end mutation loop
end # End generation/simulation loop

puts "\n\nSimulation Complete! Final stats:"
#stats.print_generations_summary
#stats.print_high_scores_with_actions
stats.print_high_scores_with_genes
