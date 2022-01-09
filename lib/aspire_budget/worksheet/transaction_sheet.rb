module AspireBudget
  module Worksheet
    class TransactionSheet < Sheet
      def initialize(**args)
      # @transaction_file = args[:transaction_file_path]
        @date_column = args[:date_column]
        @outflow_column = args[:outflow_column]
        @inflow_column = args[:inflow_column]
        @category_column = args[:category_column]
        @account_column = args[:account_column]
        @description_column = args[:description_column]
        @status_column = args[:status_column]
        @id_column = args[:id_column]
        @starting_transaction_row = args[:starting_transaction_row]
      end
    end
  end
end
