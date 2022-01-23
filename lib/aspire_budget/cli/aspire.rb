module AspireBudget
  module CLI
    class Aspire < Thor
      def self.exit_on_failure?
        true
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

      desc "configuration SUBCOMMAND ...ARGS", "Module for interacting with the Transactions Spreadsheet"
      def configuration
        client = AspireBudget::Client.new
        AspireBudget::Worksheet::ConfigurationSheet.new(client)
      end

      desc "allocate --frequency=\"semi\"", "Adds category transfers from Available to budget to categories"
      option :frequency, :type => :string, :default => "semi", :aliases => ["-f"], :banner => "\"semi\", \"monthly\""
      def allocate()
        AspireBudget.logger.info("Making Category Transfers...")
        client = AspireBudget::Client.new
        config_worksheet = AspireBudget::Worksheet::ConfigurationSheet.new(client)
        cat_transfer_worksheet = AspireBudget::Worksheet::CategoryTransferSheet.new(client)
        cat_transfer_worksheet.allocate(options[:frequency], config_worksheet.categories)
      end

      desc "transactions SUBCOMMAND ...ARGS", "Module for interacting with the Transactions Spreadsheet"
      subcommand "transactions", Transactions
    end
  end
end
