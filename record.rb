class Record
  attr_accessor :data

  def initialize(input_hash)
    @data = input_hash
    @data["sma"] = Hash.new
  end

  def purchase_price
    # we can change the returned purchase price here
    # maybe put a fudge factor in the config file
    # or return some random value between high/low of the day
    # TODO implement that later, for now it will be close price
    return @data["close"]
  end

  def sale_price
    # we can change the returned purchase price here
    # maybe put a fudge factor in the config file
    # or return some random value between high/low of the day
    # TODO implement that later, for now it will be close price
    return @data["close"]
  end

  # Can't decide if I'm going to put required methods in the this record class,
  # or add them dynamically in the gene classes (since they know what they need)
  # I guess some basic/general ones will be put here
  def avgOHLC
    return (@data["open"] + @data["high"] + @data["low"] + @data["close"]) / 4
  end

  def sma(interval)
    if interval == 0
      sma_for_interval = avgOHLC
    elsif @data["sma"].key?(interval) # if it's already been computed
      return @data["sma"][interval]   # return precomputed value
    else
      # calculate it
      # if the reqested interval is too far behind our list of records
      # then limit it to the maximum length from our current record index
      index = $records.index(self)
      if index < interval
        limited_interval = index
        sum = 0.0
        (0..limited_interval).each do |i|
          sum += $records[index - i].avgOHLC
        end
        @data["sma"][limited_interval] = sum / interval
        return @data["sma"][limited_interval]
      else
        # here is the calculation part
        sum = 0.0
        (0..interval).each do |i|
          sum += $records[index - i].avgOHLC
        end
        @data["sma"][interval] = sum / interval
        return @data["sma"][interval]
      end
    end
  end # end of sma method

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
