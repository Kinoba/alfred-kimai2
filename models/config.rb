# frozen_string_literal: true

class Config
  CONFIG_FILE_NAME = '.env'

  attr_accessor :config_file

  def initialize
    return if File.file?(CONFIG_FILE_NAME)

    config = {
      api_url: '',
      auth_user: '',
      auth_token: ''
    }
    File.open(CONFIG_FILE_NAME, 'w') { |f| f.write(config.to_json) }
  end

  def api_url
    JSON.parse(File.read(CONFIG_FILE_NAME))['api_url']
  end

  def auth_user
    JSON.parse(File.read(CONFIG_FILE_NAME))['auth_user']
  end

  def auth_token
    JSON.parse(File.read(CONFIG_FILE_NAME))['auth_token']
  end
end
