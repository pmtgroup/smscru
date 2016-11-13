require 'json'
require 'faraday'

module Smscru
  class Client
    SEND_URL = 'http://smsc.ru/sys/send.php'
    attr_reader :config

    def initialize(options={})
      @config = Smscru.config.dup
      @config.update(options)
    end

    def send_message(text, phones, options={})
      params = {
        mes:     text,
        phones:  Array(phones).join(','),
        login:   config.login,
        psw:     config.password,
        charset: 'utf-8',
        fmt:     3
      }

      connection = Faraday.new do |i|
        i.request  :url_encoded
        i.response :logger
        i.adapter  Faraday.default_adapter
      end
      response = connection.post SEND_URL, params.merge(options)

      JSON.parse(response.body)
    end

    def send_voice(text, phones, options={})
      params = {
        call: 1,
        voice: 'w3'
      }
      
      send_message(text, phones, params.merge(options))
    end
  end
end
