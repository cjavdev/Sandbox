require 'addressable/uri'
require 'rest-client'
require 'json'
require 'oauth'

class UserSession
  attr_reader :current_user

  def initialize(username, password)
    @username = username
    @password = password

    login = Addressable::URI.new(
      scheme: 'http',
      host: 'localhost',
      port: 3000,
      path: '/users/login'
    ).to_s

    @current_user = JSON.parse(RestClient.post(login, login:{ username: username, password:password }))
  end

  def get(path)
    p get_address(path)
    JSON.parse(RestClient.get(get_address(path)))
  end

  def post(path, params)
    JSON.parse(RestClient.post(get_address(path), params))
  end

  def put(path, params)
    JSON.parse(RestClient.put(get_address(path), params))
  end

  def delete(path)
    JSON.parse(RestClient.delete(get_address(path)))
  end

  def get_contacts
    get("/users/#{@current_user['id']}/contacts")
  end

  private
  def get_address(path)
    address = Addressable::URI.new(
      scheme: 'http',
      host: 'localhost',
      port: 3000,
      path: path,
      query_values: {
        token: @current_user['token']
      }
    ).to_s
  end
end


class GoogleSession
  CONSUMER_KEY =  "key"
  CONSUMER_SECRET = "secret"

  CONSUMER =  OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {:site => "https://google.com"})
  @@access_token = nil
  def self.access_token
    if @@access_token
      @@access_token
    else
      puts "inside"
      request_token = CONSUMER.get_request_token
      authorize_url = request_token.authorize_url
      Launchy.open(authorize_url)

      puts "Login, and type your verification code in"
      oauth_verifier = gets.chomp

      @@access_token = request_token.get_access_token(:oauth_verifier => oauth_verifier)
    end
  end
end

c = UserSession.new("test", "123")
 p c.get("/users/#{c.current_user['id']}/contacts")
# p c.post("/users/#{c.current_user['id']}/contacts",
#           contact: { name: 'test_contact', email: 'test_conta@ct.com',
#           phone: '3421', mail_address: '123main' })
#
#
#
#
#