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

  # This actually runs the simulation for each agent
  def calc_fitness
    #TODO fix this, run the simulation.
    @fitness = rand
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
