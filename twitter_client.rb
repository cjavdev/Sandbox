require 'launchy'
require 'oauth'
require 'json'
require 'yaml'

class TwitterSession
  CONSUMER_KEY =  "key"
  CONSUMER_SECRET = "secret"

  CONSUMER =  OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {:site => "https://twitter.com"})
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

class Status
  attr_reader :text, :user

  def initialize(author, message)
    @user = author
    @text = message
  end

  def self.parse(json)
    JSON.parse(json)
  end

  def self.parse_many(json)
    statuses = []
    JSON.parse(json.read_body).each do |status|
      statuses << Status.new(status["user"]["screen_name"], URI.unescape(status["text"]))
    end
    statuses
  end

  def mentions
    mentions = []
    @text.split(" ").each do |word|
      mentions << word.gsub(/\W/, "") if word[0] == "@"
    end
    mentions
  end

end

class Hashtag
  attr_reader :tag

  def initialize(tag)
    @tag = tag
  end

  def statuses
    statuses_query = Addressable::URI.new(
       :scheme => "https",
       :host => "api.twitter.com",
       :path => "1.1/search/tweets.json",
       :query_values => {:q => @tag,
                         :count => 10
                        }
    ).to_s

    statuses_response = TwitterSession.access_token.get(statuses_query)
    statuses = []
    JSON.parse(statuses_response.read_body)["statuses"].each do |status|
      statuses << Status.new(status["user"]["screen_name"], URI.unescape(status["text"]))
    end
    statuses
  end

end

class User
  attr_reader :timeline, :username, :access_token

  def initialize(username)
    @username = username
    @access_token = TwitterSession.access_token
  end


  def self.load(filename)
    YAML.load(File.read(filename))
  end

  def save(filename)
    File.open(filename, "w") do |f|
      f.puts self.to_yaml
    end
  end

  def self.parse(json)
    JSON.parse(json)
  end

  def self.parse_many(json)
    user_ids = JSON.parse(json)["ids"].join(",")

    username_query = Addressable::URI.new(
       :scheme => "https",
       :host => "api.twitter.com",
       :path => "1.1/users/lookup.json",
       :query_values => {:user_id => user_ids
                        }
    ).to_s

    username_response = TwitterSession.access_token.get(username_query)
    users = []
    JSON.parse(username_response.read_body).each do |user|
      users << User.new(user['name'])
    end
    users
  end

  def timeline
    #https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=twitterapi&count=2
    #
    timeline_query = Addressable::URI.new(
       :scheme => "https",
       :host => "api.twitter.com",
       :path => "1.1/statuses/user_timeline.json",
       :query_values => {:screen_name => @username,
                         :count => 5}
    ).to_s
    timeline_response =  @access_token.get(timeline_query)

    timeline = Status.parse_many(timeline_response)
    timeline.each {|status| puts "User: #{status.user}\n\nText: #{status.text}"}
    timeline

  end

  def followers
    followers_query = Addressable::URI.new(
       :scheme => "https",
       :host => "api.twitter.com",
       :path => "1.1/followers/ids.json",
       :query_values => {:screen_name => @username,
                         :count => 5000}
    ).to_s

    followers_response =  @access_token.get(followers_query)
    followers = User.parse_many(followers_response.read_body)
    followers.each {|follower| puts follower.username }
    followers
  end

  def followed_users
    friends_query = Addressable::URI.new(
       :scheme => "https",
       :host => "api.twitter.com",
       :path => "1.1/friends/ids.json",
       :query_values => {:screen_name => @username,
                         :count => 5000}
    ).to_s

    friends_response =  @access_token.get(friends_query)
    friends = User.parse_many(friends_response.read_body)
    friends.each {|friend| puts friend.username }
    friends
  end
end

class EndUser < User

  def self.set_user_name(user_name)
    @@current_user = EndUser.new(user_name)
  end

  def self.me
    @@current_user
  end

  def post_status(status_text)
    s = Status.new(@username, URI.unescape(status_text).to_s)
    status_query = Addressable::URI.new(
       :scheme => "https",
       :host => "api.twitter.com",
       :path => "1/statuses/update.json",
       :query_values => { :status => s.text }
    ).to_s
    @access_token.post(status_query).body

  end

  def direct_message(other_user, text)
    d = Status.new(@username, URI.unescape(text))
    dm_query = Addressable::URI.new(
       :scheme => "https",
       :host => "api.twitter.com",
       :path => "1/direct_messages/new.json",
       :query_values => { :screen_name => other_user,
                          :text => text}
    ).to_s

    @access_token.post(dm_query).body
  end

end


#p TwitterSession.access_token