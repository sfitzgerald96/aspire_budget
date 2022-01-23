module AspireBudget
  class Category
    attr_reader :monthly_amount, :money_available
    attr_accessor :symbol, :name, :goal_amount, :included_in_emergency
    def initialize(**args)
      @symbol = args[:symbol]
      @name = args[:name]
      monthly_amount = args[:monthly_amount]
      @goal_amount = args[:goal_amount]
      @included_in_emergency = args[:included_in_emergency]
      money_available = args[:money_available]
    end

    def monthly_amount=(value)
      @monthly_amount = convert_to_currency(value)
    end

    def money_available=(value)
      @money_available = convert_to_currency(value)
    end

    private
    def convert_to_currency(value)
      if value.instance_of?(String)
        return value.gsub("$",'').gsub(',', '').to_f
      else
        return value
      end
    end
  end
end