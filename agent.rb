class Agent
  attr_accessor :genes, :allowed_actions, :action_log, :total_value
  attr_accessor :last_sale_action_index, :last_buy_action_index
  attr_accessor :settled_cash, :unsettled_cash, :trade_cost, :shares
  attr_reader :fitness, :starting_cash

  # Constructor
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

    # TODO I need to put all these variables in a hash for easy printing....

    # initialize the possible actions
    @action_log = Array.new  # will be an array of hashes for each action per step/day
    @last_buy_action_index = nil    # kinda jank...
    @last_sale_action_index = nil   # kinda jank...

    # pull in the startingCash amount, etc
    @starting_cash = conf["agent"]["startingCash"]
    @settled_cash = conf["agent"]["startingCash"]
    @unsettled_cash = 0.0
    @settle_cash_interval = conf["agent"]["settleCashInterval"]
    @trade_cost = conf["agent"]["tradeCost"]
    @shares = 0
  end # init end

  def run_sim(records, sim_start_index, sim_end_index)
    # this limits the simulation start and end dates
    for i in sim_start_index..sim_end_index do
      step(records[i], i)
    end
    #TODO fix this to account for baseline?
    @fitness = @total_value / @starting_cash
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

    # Score the state decisions
    buy_score = score_buy(record, index)
    sell_score = score_sell(record, index)
    hold_score = score_hold(record, index, buy_score, sell_score)

    # then check what states are available to us (buy/sell/hold)
    # this time I am planning on not killing off bad decisions that break rules
    # I will limit available decisions (such as not able to sell if don't own, etc)

    # Execute the state decision (But limiting to available/possible options)
    if buy_score > sell_score && buy_score > hold_score
      # TODO check available allowed_actions. I think the only limitation is on
      # buying within 3 days (before cash has settled)
      execute_buy(record, index)
    elsif sell_score > buy_score && sell_score > hold_score
      execute_sell(record, index)
    else
      execute_hold(record, index)
    end

    # update the total_current_value
    @total_value = total_current_value(record)
  end # step method end

  def score_buy(record, index)
    # remember that this must return a normalized value, according to how
    # many items it scored, so that actions with lots of genes don't get
    # preferential treatement
    sum = 0.0
    @genes["buy"].each do |gene|
      sum += gene.calc(record)
    end
    return sum / @genes["buy"].size   # normalize by dividing by the number of genes
  end

  def score_sell(record, index)
    sum = 0.0
    @genes["sell"].each do |gene|
      sum += gene.calc(record)
    end
    return sum / @genes["sell"].size
  end

  def score_hold(record, index, buy, hold)
    sum = 0.0
    @genes["hold"].each do |gene|
      sum += gene.calc(record)
    end
    return sum / @genes["hold"].size
  end

  def execute_buy(record, index)
    # bookeeping first
    if @settled_cash > (record.purchase_price + @trade_cost) # we have enough to buy at least 1 share
      shares_to_buy = ((@settled_cash - @trade_cost) / record.purchase_price).to_i
      transaction_cost = shares_to_buy * record.purchase_price + @trade_cost
      @settled_cash -= transaction_cost
      @shares = shares_to_buy
      @last_buy_action_index = index
      add_action_to_log("buy", record, index)
    else
      add_action_to_log("unsuccessful_buy", record, index)
    end
  end

  def execute_sell(record, index)
    if @shares >= 1
      transaction_profit = @shares * record.sale_price
      @unsettled_cash += transaction_profit - @trade_cost
      @shares = 0
      @last_sale_action_index = index
      add_action_to_log("sell", record, index)
    else
      add_action_to_log("unsuccessful_sell", record, index)
    end
  end

  def execute_hold(record, index)
    # nothing to do here right now except add to the action log
    add_action_to_log("hold", record, index)
  end

  def add_action_to_log(action, record, index)
    @action_log << { id: index, action: action, total_value: total_current_value(record).to_f,
      settled_cash: @settled_cash.to_f, unsettled_cash: @unsettled_cash.to_f, shares: @shares }   # need to fill in more info here
  end

  # need to make a way to get value without a record...
  def total_current_value(record)
    return @settled_cash + @unsettled_cash + (@shares * record.sale_price)
  end

  def xover(other)
    # create a child
    child = Agent.new(@conf)
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

  def genes_to_JSON
    genes_json_copy = Hash.new
    @genes.each do |gene_action_type, sub_genes|
      genes_json_copy["#{gene_action_type}"] = Array.new
      sub_genes.each_with_index do |gene, index|
        genes_json_copy["#{gene_action_type}"] << Hash.new
        genes_json_copy["#{gene_action_type}"][index]["#{gene.class}"] = gene.codons
      end
    end
    return genes_json_copy
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
