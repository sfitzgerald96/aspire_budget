module AspireBudget
  module Worksheet
    class Dashboard < Sheet
      module COLUMNS
        CATEGORY_NAME = 7
        AVAILABLE = 8
      end

      module ROWS 
        STARTING_CATEGORY = 6
      end

      attr_reader :sheet
      def initialize(client)
        @sheet = client.spreadsheet.worksheet_by_title('Dashboard')
      end

      def overspent_categories()
        categories = []
        @sheet.rows[ROWS::STARTING_CATEGORY..-1].each do |row|
          next if row[COLUMNS::CATEGORY_NAME].empty?
          category = AspireBudget::Category.new
          category.name = row[COLUMNS::CATEGORY_NAME]
          category.money_available = row[COLUMNS::AVAILABLE]
          next if category.money_available >= 0
          categories.push(category)
        end
        return categories
      end
    end
  end
end