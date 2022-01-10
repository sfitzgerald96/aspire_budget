module AspireBudget
  class Transaction

    attr_accessor :uuid, :date, :outflow, :inflow, :category, :account, :description, :status

    def initialize(uuid:, date:, outflow:, inflow:, category:, account:, description:, status:)
      @date = date
      @outflow = outflow
      @inflow = inflow
      @category = category
      @account = account
      @description = description
      @status = status
      @uuid = uuid
    end

    def self.from_csv(csv)
      transactions = []
      file = File.open(csv, 'r:UTF-8')
      line = nil

      begin
        while line = file.gets
          AspireBudget.logger.debug "Reading: #{line}"
          transaction = self.from_csv_line(line.strip) if line
          transactions << transaction if line && transaction
        end
      rescue
        # reached end of file
      end

      return transactions
    end

    def self.from_csv_line(line)
      parts = line.split(',')
      return nil if parts.length != 8

      return Transaction.new(
        date: DateTime.strptime(parts[0], "%d-%b"),
        outflow: parts[1].gsub("$",'').gsub(',', '').to_f,
        inflow: parts[2].gsub("$",'').gsub(',', '').to_f,
        category: parts[3],
        account: parts[4],
        description: parts[5],
        status: parts[6],
        uuid: parts[7]
      )
    end
  end
end
