class Agent
  attr_accessor :genes, :current_cash
  attr_reader :fitness, :starting_cash

  def initialize(conf)
    #save the config for later
    @conf = conf
    # make our genome arrays
    @genes = Hash.new
    @genes["buy"] = Array.new
    @genes["sell"] = Array.new
    @genes["hold"] = Array.new
    # pull in the startingCash amount
    @starting_cash = conf["agent"]["startingCash"]
    @current_cash = conf["agent"]["startingCash"]
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
  end # init end

  # This actually runs the simulation for each agent
  def calc_fitness
    #TODO fix this, run the simulation.
    @fitness = rand
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

  def genes_to_string
    result = "Genes: "
    @genes.each do |gene_action_type, genes|
      result = "#{result}\n #{gene_action_type}:"
      genes.each do |gene|
        result = "#{result} #{gene.class.name}: #{gene.to_string}"
      end
    end
    return result
  end
end # class end
