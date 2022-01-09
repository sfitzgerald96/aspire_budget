GOOGLE_SHEET_ID='1nDHRLoAQW3qUi8THbcBLp6t3C1Lm6sR2G-sQ0pVMuns'
module AspireBudget
  class Client
    attr_accessor :datastore
    attr_reader :google_sheet_id, :session, :spreadsheet

    def initialize(config_path: "config.json", **args)
      @google_sheet_id = (args[:google_sheet_id] || GOOGLE_SHEET_ID).to_s
      @session = GoogleDrive::Session.from_config(config_path)
      @spreadsheet = @session.spreadsheet_by_key(@google_sheet_id)
    end
  end
end
