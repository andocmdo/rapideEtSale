class Agent
  attr_accessor :genes, :allowed_actions, :actions
  attr_accessor :last_sale_action_index, :last_buy_action_index
  attr_accessor :settled_cash, :unsettled_cash
  attr_reader :fitness, :starting_cash

  def initialize(conf)
    #save the config for later
    @conf = conf

    # make our genome arrays
    @genes = Hash.new
    @genes["buy"] = Array.new
    @genes["sell"] = Array.new
    @genes["hold"] = Array.new

    # Now load in the appropriate files/classes for genome
    conf["agent"]["buyGenes"].each do |gene_class|
      @genes["buy"] << Object.const_get(gene_class).new
    end
    conf["agent"]["sellGenes"].each do |gene_class|
      @genes["sell"] << Object.const_get(gene_class).new
    end
    conf["agent"]["holdGenes"].each do |gene_class|
      @genes["hold"] << Object.const_get(gene_class).new
    end

    # initialize the possible actions
    @allowed_actions = ["buy", "sell", "hold"]
    @actions = Array.new  # will be an array of hashes for each action per step/day
    @last_buy_action_index = nil    # kinda jank...
    @last_sale_action_index = nil   # kinda jank...

    # pull in the startingCash amount
    @starting_cash = conf["agent"]["startingCash"]
    @settled_cash = conf["agent"]["startingCash"]
    @unsettled_cash = 0.0
    @settle_cash_interval = conf["agent"]["settleCashInterval"]
  end # init end

  # This actually runs the simulation for each agent
  def run_sim(records)
    #TODO fix this, run the simulation.
    records.each_with_index do |record, index|
      step(record, index)
    end
    @fitness = rand   #TODO fix this to actually use the simulation score
  end

  def step(record, index)
    # bookeeping first
    # must settle cash for past sell transactions, etc
    if @unsettled_cash > 0.0
      # check the time since last sell and settle cash if
      # it's over the time allowed (3 days?)
      if (index - @last_sale_action_index) > @settle_cash_interval
        @settled_cash += @unsettled_cash
        @unsettled_cash = 0.0
      end
    end
    # I was going to add a wait time for selling a stock, but skipping that now
    # per rules that say you can sell immediately the next day without being
    # flagged a day trader


    # then check what states are available to us (buy/sell/hold)
    # this time I am planning on not killing off bad decisions that break rules
    # I will limit available decisions (such as not able to sell if don't own, etc)

    # Score the state decisions


    # Execute the state decision (But limiting to available/possible options)

  end

  def score_buy

  end

  def score_sell

  end

  def score_hold

  end

  def execute_buy

  end

  def execute_sell

  end

  def execute_hold
    # nothing to do here right now except add to the action log
    @actions << { action: "hold" }
  end

  def xover(other)
    # create a child
    child = Agent.new(@conf)
    #puts "DEBUG XOVER"
    #puts "child: genes: #{genes} "
    # mix genes from 50% of each parent into the child
    child.genes.each do |gene_action_type, gene_class_array|  # buy, sell, hold
      gene_class_array.each_with_index do |gene_class, gene_class_index|  # gene classes
        gene_class.codons.each do |codon_key, codon_val|                  # codons
          if rand < 0.5
            # from us (parentA)
            child.genes[gene_action_type][gene_class_index].codons[codon_key] = genes[gene_action_type][gene_class_index].codons[codon_key]
          else
            # from other (parentB)
            child.genes[gene_action_type][gene_class_index].codons[codon_key] = other.genes[gene_action_type][gene_class_index].codons[codon_key]
          end
        end
      end
    end
    return child
  end

  def mutate(rate)
    @genes.each do |gene_action_type, sub_genes|
      sub_genes.each do |gene|
        gene.mutate(rate)
      end
    end
  end

  def genes_to_string
    result = "Genes: "
    @genes.each do |gene_action_type, sub_genes|
      result = "#{result}\n #{gene_action_type}:"
      sub_genes.each do |gene|
        result = "#{result} #{gene.class.name}: #{gene.to_string}"
      end
    end
    return result
  end
end # class end
