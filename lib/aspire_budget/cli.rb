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

    desc "configure", "Modifies config for the aspire budget client"
    long_desc <<-LONGDESC
      `aspire configure` will run through a command prompt asking you for various config:

        --->Google Sheet ID: This can be found from the url of your google spreadsheet https://docs.google.com/spreadsheets/d/#{"2bYz_Yo7jqMjiIR32bCObExp9-BE3NOZM8Hoozb9Zy7G".yellow}/edit#gid=0

        --->Client ID: This can be generated following these steps https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md#on-behalf-of-you-command-line-authorization

        --->Client Secret: This can be generated following these steps https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md#on-behalf-of-you-command-line-authorization

        --->Refresh Token: Can either be a session that lasts forever, or a session that lasts for only 1-hour.
    LONGDESC
    def configure
      AspireBudget::Authorization.prompt_user_for_config
    end

    private

    def verify_config
      unless File.exist?('config.json')
        AspireBudget::Authorization.prompt_user_for_config
      end 
    end
  end
end
