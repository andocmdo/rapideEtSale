class Record
  attr_accessor :data

  def initialize(input_hash)
<<<<<<< HEAD
    @data = input_hash
=======
    @record_hash = input_hash
>>>>>>> 6f8c15fae7d8fee0a6f2bdf8f7c17ad83f9f38fe
  end

  def purchase_price
    # we can change the returned purchase price here
    # maybe put a fudge factor in the config file
    # or return some random value between high/low of the day
    # TODO implement that later, for now it will be close price
<<<<<<< HEAD
    return @data["close"]
=======
    return @record_hash["close"]
>>>>>>> 6f8c15fae7d8fee0a6f2bdf8f7c17ad83f9f38fe
  end

  def sale_price
    # we can change the returned purchase price here
    # maybe put a fudge factor in the config file
    # or return some random value between high/low of the day
    # TODO implement that later, for now it will be close price
<<<<<<< HEAD
    return @data["close"]
  end

### Static method for loading records
  def self.load_records(config) # I'd like to make this a specific hash only...
    host = config["records"]["host"]
    username = config["records"]["username"]
    password = config["records"]["password"]
    database = config["records"]["database"]
    table = config["records"]["table"]
    symbol = config["records"]["symbol"]
    ldate_from = config["records"]["ldateFrom"]
    ldate_to = config["records"]["ldateTo"]

    records_array = Array.new

    client = Mysql2::Client.new(:host => host, :username => username, :password => password, :database => database)
    results = client.query("SELECT * FROM #{table} WHERE symbol='#{symbol}' AND ldate>=#{ldate_from} AND ldate<=#{ldate_to} ORDER BY ldate")

    results.each do |row_hash|
      records_array << Record.new(row_hash)
    end
    return records_array
  end # end of load_records
=======
    return @record_hash["close"]
  end
>>>>>>> 6f8c15fae7d8fee0a6f2bdf8f7c17ad83f9f38fe

### Static method for loading records 
  def self.load_records(config) # I'd like to make this a specific hash only...
    host = config["records"]["host"]
    username = config["records"]["username"]
    password = config["records"]["password"]
    database = config["records"]["database"]
    table = config["records"]["table"]
    symbol = config["records"]["symbol"]
    ldate_from = config["records"]["ldateFrom"]
    ldate_to = config["records"]["ldateTo"]

    records_array = Array.new

    client = Mysql2::Client.new(:host => host, :username => username, :password => password, :database => database)
    results = client.query("SELECT * FROM #{table} WHERE symbol='#{symbol}' AND ldate>=#{ldate_from} AND ldate<=#{ldate_to} ORDER BY ldate")

    results.each do |row_hash|
      records_array << Record.new(row_hash)
    end
    return records_array
  end # end of load_records

end # class end
