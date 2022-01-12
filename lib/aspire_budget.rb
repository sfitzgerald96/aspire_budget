# 3rd party gems
require "google_drive"
require "byebug"
require 'json'

# base files
require "aspire_budget/version"
require "aspire_budget/client"
require "aspire_budget/transaction"
require "aspire_budget/colorize"
require "aspire_budget/cli"
require "aspire_budget/authorization"

# worksheet files
require "aspire_budget/worksheet/sheet"
require "aspire_budget/worksheet/transaction_sheet"
require "aspire_budget/worksheet/configuration_sheet"
require "aspire_budget/worksheet/category_transfer_sheet"

module AspireBudget
  CONFIG_PATH = 'test.json'

  module ConfigKeys
    CLIENT_ID = "client_id"
    CLIENT_SECRET = "client_secret"
    SCOPE = "scope"
    REFRESH_TOKEN = "refresh_token"
    GOOGLE_SHEET_ID = "google_sheet_id"
  end

  class << self
    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = self.name
        log.level = Logger::DEBUG
      end
    end
  end

  class Error < StandardError; end
  # Your code goes here...
end
