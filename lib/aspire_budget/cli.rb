require 'thor'
 
module AspireBudget
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "add_transactions CSV", "Adds transactions from a csv path"
    def add_transactions(csv)
      verify_config
      AspireBudget.logger.info("Adding Transactions...")
      client = AspireBudget::Client.new
      transaction_worksheet = AspireBudget::Worksheet::TransactionSheet.new(client)
      byebug
    end

    private

    def verify_config
      unless File.exist?('config.json')
        AspireBudget::Authorization.prompt_user_for_config
      end 
    end
  end
end
