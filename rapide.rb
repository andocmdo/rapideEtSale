##### Remember: Quick and Dirty this time...
require 'json'
require 'descriptive_statistics'
require_relative 'agent'
require_relative 'high_scores_and_stats'
require_relative 'gene_classes'

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
  puts "Generation: #{generation}"    # TODO remove for debug

  # run agents through sim and calculate fitness
  scores = Array.new
  population.each do |agent|
    scores << agent.calc_fitness
  end
  # feed that hash info to the stats tracker, who will then pull back out
  # the agents that have top scores
  puts scores   # TODO remove for debug
  stats.feed(scores, population)
  stats.print_high_scores

  # xover


  # mutate
end

puts "\nSimulation Complete!"
stats.print_generations_summary
stats.print_high_scores
