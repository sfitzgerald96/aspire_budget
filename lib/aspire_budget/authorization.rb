require "googleauth"
module AspireBudget
  class Authorization
    class << self
      def prompt_user_for_config
        puts "Follow these steps to generate a client id and client secret"
        puts "https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md#on-behalf-of-you-command-line-authorization"
  
        print "client_id: "
        client_id = STDIN.gets.chomp
  
        print "client_secret: "
        client_secret = STDIN.gets.chomp
  
        refresh_token = nil
        while true
          print "Would you like a session that lasts indefinitely? (Y/n) "
          is_persistent = STDIN.gets.chomp
          if is_persistent.upcase == 'Y' || is_persistent.upcase == 'YES'
            refresh_token = AspireBudget::Authorization.generate_refresh_token client_id, client_secret, true
            break
          elsif is_persistent.upcase == 'N' || is_persistent.upcase == 'NO'
            puts "Ok, your session will only last 1-hour."
            refresh_token = AspireBudget::Authorization.generate_refresh_token client_id, client_secret
            break
          else
            puts "Invalid option. Please try again."
          end
        end
  
        config = {
          "client_id": client_id.to_s,
          "client_secret": client_secret.to_s,
          "scope": [
            "https://www.googleapis.com/auth/drive",
            "https://spreadsheets.google.com/feeds/"
          ],
          "refresh_token": refresh_token.to_s
        }
  
        File.open("test.json","w") do |f|
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
    end
  end
end