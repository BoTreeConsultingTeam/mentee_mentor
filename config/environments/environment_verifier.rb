module EnvironmentVerifier
  def self.note_to_developers
    puts <<WHERE_CLAUSE
        # Note to developers:
        # Please do not commit /config/settings.yml with any secured keys or
        # secrets within in it.For development purpose take the following approach
        # to work with your secured data.

        # Place a file named secured_settings.yml at location /config/settings and
        # override the secured keys(by default empty in /config/settings.yml) in this
        # secured_settings.yml file.This should allow you to use your confidential keys
        # and secrets for development purpose without requiring them to commit to
        # the repository.
        # Note: /config/settings/development.yml checks for existence of file
        # /config/settings/secured_settings.yml and if available uses the values taking
        # precedence over identical keys in /config/settings.yml.If using a custom
        # environment make sure you include /config/settings/secured_settings.yml to
        # take advantage of this approach.For reference see development environment
        # settings file available at: /config/settings/development.yml
WHERE_CLAUSE
  end

  def self.auth_providers_settings_available?
    auth_providers = %w(facebook)
    if Settings.try(:omniauth)
      flag = true
      auth_providers.each do |provider|
        details = Settings.omniauth.try(provider.to_sym)

        unless details.nil?
          key = details.key
          secret = details.secret

          if (key.blank? and secret.blank?)
            puts "Under /config/settings.yml, please replace omniauth.#{provider}.key and omniauth.#{provider}.secret with the application key and secret provided when created an app with #{provider.capitalize}."
            puts "Without these settings 'Login through #{provider.capitalize}' feature would not work."
            puts "If you do not have the #{provider} app settings remove the #{provider} and its child keys from /config/settings.yml."
            flag = false
            break
          end
        end
      end
      return flag
    else
      puts "Under /config/settings.yml, please define required values in following format:"
      puts "omniauth:"
      auth_providers.each do |provider|
        puts "  #{provider}:"
        puts "    key:"
        puts "    secret:"
      end
      return false
    end
  end

  def self.mail_settings_available?
    keys = %w(address port domain user_name password)
    if Settings.try(:mail)
      flag = true
      keys.each do |key|
        details = Settings.try(:mail).try(key.to_sym)
        flag = (flag and !key.blank?)
      end
      return flag
    else
      puts "Under /config/settings.yml, please define mail settings in following format:"
      puts "mail:"
      keys.each do |key|
        puts "  #{key}:"
      end
      return false
    end
  end
end

