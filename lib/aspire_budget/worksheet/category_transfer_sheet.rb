module AspireBudget
  module Worksheet
    class CategoryTransferSheet < Sheet
      module COLUMNS
        DATE = 2
        AMOUNT = 3
        FROM_CATEGORY = 4
        TO_CATEGORY = 5
        MEMO = 6
      end

      attr_reader :sheet
      def initialize(client, **args)
        @sheet = client.spreadsheet.worksheet_by_title('Category Transfers')
        @current_row = @sheet.rows.count
      end

      def increment_current_row(count=1)
        @current_row += count
      end

      def find_next_blank_row()
        return @sheet.rows.count + 1
      end

      def transfer_available_to(category, amount, memo="")
        @current_row = find_next_blank_row
        @sheet[@current_row, COLUMNS::DATE] = Time.now.strftime("%m/%d/%Y")
        @sheet[@current_row, COLUMNS::AMOUNT] = amount
        @sheet[@current_row, COLUMNS::FROM_CATEGORY] = "Available to budget"
        @sheet[@current_row, COLUMNS::TO_CATEGORY] = category.name
        @sheet[@current_row, COLUMNS::MEMO] = memo
      end

      def allocate(frequency, categories)
        @current_row = find_next_blank_row
        categories.each do |category|
          next if category.monthly_amount.zero?
          multiplier = frequency == "semi" ? 0.5 : 1
          amount = (category.monthly_amount * multiplier).ceil(2)
          transfer_available_to(category, amount, frequency)
        end
        @sheet.save
      end
    end
  end
end