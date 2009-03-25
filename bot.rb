require 'rubygems'
require 'twibot' # our bot helper
require 'active_record' # db
require 'feedzirra' # feed helper


ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :username => "root",
  :host => "127.0.0.1",
  :password => "",
  :database => "twibot"
)

class Tweets < ActiveRecord::Base
end


###
#  What we want the bot to do
###
#  1. Listen to an rss feed and store that stuff 
#  2. Work out which tweets need to be tweeted by the bot
#  3. send the tweets and mark them as 'tweeted'
#

feed_thread = Thread.new do
  while(true != false)
    # fetch the feed
    feed = Feedzirra::Feed.fetch_and_parse("http://search.twitter.com/search.atom?q=+%23sor09")

    feed.entries.each do |entry|
      tweet = Tweets.find_or_create_by_twitter_id(
                :twitter_id => entry.id,
                :published  => entry.published,
                :title      => entry.title
              )

      if tweet.tweeted.blank?
        post_tweet "#{tweet.twitter_id}"
        tweet.update_attribute(:tweeted, true)
      end
    end

  end
end


# Receive messages, and tweet them publicly
#
#message do |message, params|
#  post_tweet message
#end

# Respond to @replies if they come from the right crowd
#
#reply :from => [:cjno, :irbno] do |message, params|
#  post_tweet "@#{message.sender.screen_name} I agree"
#end

# Listen in and log tweets
#
tweet do |message, params|
  MyApp.log_tweet(message)
end


