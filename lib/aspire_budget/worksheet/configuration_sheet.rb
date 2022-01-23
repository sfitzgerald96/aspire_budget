module AspireBudget
  module Worksheet
    class ConfigurationSheet < Sheet
      module UNICODE_CHARACTERS
        GROUP = "\u2726"
        CATEGORY = "\u2727"
        BOMB_BLAST = "\u203b"
        CREDIT_CARD = "\u25d8"
      end

      module ROWS
        STARTING_CATEGORY = 8
      end

      module COLUMNS
        SYMBOL = 1
        NAME = 2
        MONTHLY_AMOUNT = 3
        GOAL_AMOUNT = 4
        INCLUDED_IN_EMERGENCY = 5
      end

      attr_reader :sheet, :categories
      def initialize(client, **args)
        @sheet = client.spreadsheet.worksheet_by_title('Configuration')
        @categories = get_categories
      end

      def get_categories
        categories = []
        @sheet.rows[ROWS::STARTING_CATEGORY..-1].each do |row|
          next if row[COLUMNS::SYMBOL].empty?
          next if row[COLUMNS::SYMBOL] == UNICODE_CHARACTERS::GROUP

          category = AspireBudget::Category.new
          category.symbol = row[COLUMNS::SYMBOL]
          category.name = row[COLUMNS::NAME]
          category.monthly_amount = row[COLUMNS::MONTHLY_AMOUNT]
          category.goal_amount = row[COLUMNS::GOAL_AMOUNT]
          category.included_in_emergency = row[COLUMNS::INCLUDED_IN_EMERGENCY]

          categories.push category
        end
        return categories
      end
    end
  end
end