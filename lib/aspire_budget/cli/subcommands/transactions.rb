
module AspireBudget
  module CLI
    class Transactions < Thor
      def self.exit_on_failure?
        true
      end

      desc "add csv_path", "Adds transactions from a csv path"
      def add(csv_path)
        AspireBudget.logger.info("Adding Transactions...")
        client = AspireBudget::Client.new
        transaction_worksheet = AspireBudget::Worksheet::TransactionSheet.new(client)
        transactions = AspireBudget::Transaction.from_csv(csv_path)
        transaction_worksheet.add_transactions(transactions)
      end
    end
  end
end