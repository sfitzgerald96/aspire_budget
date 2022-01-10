module AspireBudget
  module Worksheet
    class TransactionSheet < Sheet
      ADDITIONAL_TXNS = [
          "transaction-1336879882", "transaction-1336481416", "transaction-1336481413", "transaction-1336453840", "transaction-1336879801", "transaction-1336879800", "transaction-1336481421", "transaction-1336481417", "transaction-1336481415", "transaction-1336481414",
          "transaction-1336453841", "transaction-1336879802", "transaction-1335474691", "transaction-1335474689", "transaction-1335474692", "transaction-1335805381", "transaction-1335113421", "transaction-1335113420", "transaction-1334946958", "transaction-1334509724",
          "transaction-1334509723", "transaction-1335805387", "transaction-1335805385", "transaction-1335805383", "transaction-1334353215", "transaction-1334353214", "transaction-1334353213", "transaction-1334315483", "transaction-1334261262", "transaction-1334261261",
          "transaction-1334261260", "transaction-1333903315", "transaction-1333903314", "transaction-1333903313", "transaction-1333903312", "transaction-1333803465", "transaction-1333788114", "transaction-1333788113", "transaction-1333788111", "transaction-1335805388",
          "transaction-1335805386", "transaction-1335805384", "transaction-1335805382", "transaction-1333790982", "transaction-1333790981", "transaction-1333357517", "transaction-1332864331", "transaction-1332864336", "transaction-1332458958", "transaction-1332413774",
          "transaction-1332413773", "transaction-1332413772", "transaction-1332413771", "transaction-1332413770", "transaction-1332413769", "transaction-1331954379", "transaction-1331954378", "transaction-1331954377", "transaction-1331954376", "transaction-1331954375",
          "transaction-1332864335", "transaction-1331954482", "transaction-1331823520", "transaction-1331610433", "transaction-1331599825", "transaction-1331530039", "transaction-1331002001", "transaction-1331002000", "transaction-1331823528", "transaction-1330969548",
          "transaction-1330969547", "transaction-1330969546", "transaction-1330969545", "transaction-1330407606", "transaction-1331823526", "transaction-1331823523", "transaction-1330125333", "transaction-1329498081", "transaction-1329498080", "transaction-1329498079",
          "transaction-1329338499", "transaction-1329338498"
      ]

      attr_reader :client, :sheet, :date_column, :outflow_column, :inflow_column, :category_column, :account_column,
                  :description_column, :status_column, :id_column, :starting_transaction_row,
                  :datastore, :current_row

      def initialize(client, **args)
        @sheet = client.spreadsheet.worksheet_by_title('Transactions')
        @date_column = (args[:date_column] || 2).to_i
        @outflow_column = (args[:outflow_column] || 3).to_i
        @inflow_column = (args[:inflow_column] || 4).to_i
        @category_column = (args[:category_column] || 5).to_i
        @account_column = (args[:account_column] || 6).to_i
        @description_column = (args[:description_column] || 7).to_i
        @status_column = (args[:status_column] || 8).to_i
        @id_column = (args[:id_column] || 9).to_i
        @starting_transaction_row = (args[:starting_transaction_row] || 9).to_i
        @datastore = args[:datastore] || Hash.new
        @current_row = @starting_transaction_row
        populate_datastore
      end

      def increment_current_row(count=1)
        @current_row += count
      end

      def find_next_blank_row()
        return @sheet.rows.count + 1
      end

      def add_transactions(transactions)
        @current_row = find_next_blank_row

        # transactions.reject! do |transaction|
        #   transaction.
        # end

        transactions.each do |transaction|
          AspireBudget.logger.debug "Syncing: #{transaction.uuid}"

          @sheet[@current_row, @date_column] = transaction.date.strftime("%d-%b")
          @sheet[@current_row, @outflow_column] = transaction.outflow unless transaction.outflow.zero?
          @sheet[@current_row, @inflow_column] = transaction.inflow unless transaction.inflow.zero?
          @sheet[@current_row, @category_column] = transaction.category
          @sheet[@current_row, @account_column] = transaction.account
          @sheet[@current_row, @description_column] = transaction.description
          @sheet[@current_row, @status_column] = transaction.status
          @sheet[@current_row, @id_column] = transaction.uuid
          @sheet.save

          increment_current_row
        end
      end

      private

      def populate_datastore
        populate_additional_txns
        row = @starting_transaction_row
        while @sheet[row, @date_column] != '' || @sheet[row, @id_column] != ''
          uuid = @sheet[row, @id_column]
          @datastore[uuid] = true
          row += 1
        end
      end

      def populate_additional_txns
        ADDITIONAL_TXNS.each do |txn|
          @datastore[txn] = true
        end
      end
    end
  end
end
