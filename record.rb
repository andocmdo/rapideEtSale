class Record
  attr_reader :record_hash

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

    results.each do |row|
      records_array << row
    end
    return records_array
  end

  def initialize(input_hash)
    @record_hash = input_hash
  end

end # class end
