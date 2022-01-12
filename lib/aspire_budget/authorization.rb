require "googleauth"
module AspireBudget
  class Authorization
    class << self
      def prompt_user_for_config
        credentials = Hash.new
        config = Hash.new
        if File.exist?(AspireBudget::CONFIG_PATH)
          config = JSON.parse(File.read(AspireBudget::CONFIG_PATH))
        end

        print "Google Sheet ID #{mask_config_value(config, ConfigKeys::GOOGLE_SHEET_ID)}: "
        google_sheet_id = get_user_input_for(config, ConfigKeys::GOOGLE_SHEET_ID)

        print "Client ID #{mask_config_value(config, ConfigKeys::CLIENT_ID)}: "
        credentials[ConfigKeys::CLIENT_ID] = get_user_input_for(config, ConfigKeys::CLIENT_ID)

        print "Client Secret #{mask_config_value(config, ConfigKeys::CLIENT_SECRET)}: "
        credentials[ConfigKeys::CLIENT_SECRET] = get_user_input_for(config, ConfigKeys::CLIENT_SECRET)

        print "Would you like a session that lasts indefinitely? (Y/n) "
        refresh_token = get_user_input_for(config, ConfigKeys::REFRESH_TOKEN, credentials)
  
        config = {
          ConfigKeys::CLIENT_ID => credentials[ConfigKeys::CLIENT_ID],
          ConfigKeys::CLIENT_SECRET => credentials[ConfigKeys::CLIENT_SECRET],
          ConfigKeys::SCOPE => [
            "https://www.googleapis.com/auth/drive",
            "https://spreadsheets.google.com/feeds/"
          ],
          ConfigKeys::REFRESH_TOKEN => refresh_token.to_s,
          ConfigKeys::GOOGLE_SHEET_ID => google_sheet_id.to_s
        }
  
        File.open(AspireBudget::CONFIG_PATH, "w") do |f|
          f.write(JSON.pretty_generate(config))
        end
      end

      def generate_refresh_token(client_id, client_secret, is_persistent = false)
        # TODO: implement this
        if is_persistent
          return "persistent_token"
        else
          return "refresh_token"
        end
      end

      private

      def mask_config_value(config, key)
        mask = "*" * 10
        config_value = config[key].to_s

        if config_value.empty?
          return "[None]"
        elsif key == "client_id"
          client_id_subdomain = config_value.split('.').first
          last_chars = client_id_subdomain.chars.last(4).join
        else
          last_chars = config_value.to_s.chars.last(4).join
        end

        return "[#{mask}#{last_chars}]"
      end

      def get_user_input_for(config, key, credentials = nil)
        input = STDIN.gets.chomp
        if key == ConfigKeys::REFRESH_TOKEN
          while true
            if input.upcase == 'Y' || input.upcase == 'YES'
              return generate_refresh_token(credentials[ConfigKeys::CLIENT_ID], credentials[ConfigKeys::CLIENT_SECRET], true)
              break
            elsif input.upcase == 'N' || input.upcase == 'NO'
              puts "Ok, your session will only last 1-hour.".yellow
              return generate_refresh_token(credentials[ConfigKeys::CLIENT_ID], credentials[ConfigKeys::CLIENT_SECRET], false)
              break
            elsif input.empty? && !config[ConfigKeys::REFRESH_TOKEN].empty?
              return config[key]
            else
              puts "Invalid input. Please try again."
            end
          end
        elsif input.empty?
          return config[key]
        else
          return input
        end
      end
    end
  end
end