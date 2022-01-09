module AspireBudget
  class Client
    def initialize(**args)
      @google_sheet_id = args[:google_sheet_id].to_s
      @datastore = args[:datastore].to_h
    end

    
  end
end
