module AspireBudget
  class Category
    attr_reader :monthly_amount
    attr_accessor :symbol, :name, :goal_amount, :included_in_emergency
    def initialize(**args)
      @symbol = args[:symbol]
      @name = args[:name]
      monthly_amount = args[:monthly_amount]
      @goal_amount = args[:goal_amount]
      @included_in_emergency = args[:included_in_emergency]
    end

    def monthly_amount=(value)
      if value.instance_of?(String)
        @monthly_amount = value.gsub("$",'').gsub(',', '').to_f
      else
        @monthly_amount = value
      end
    end
  end
end