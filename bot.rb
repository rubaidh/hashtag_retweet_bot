require 'rubygems'
require 'twibot' # our bot helper
require 'active_record' # db
require 'feedzirra' # feed helper


ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :username => "root",
  :host => "localhost",
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
begin
      # fetch the feed
      feed = Feedzirra::Feed.fetch_and_parse("http://search.twitter.com/search.atom?q=+%23sor09")

      feed.entries.reverse.each do |entry|
        tweet = Tweets.find_or_create_by_twitter_id(
                  :twitter_id => entry.id,
                  :published  => entry.published,
                  :title      => entry.title,
                  :content    => entry.content,
                  :link       => entry.url
                )

        if tweet.tweeted.blank?
          #post_tweet "#{tweet.link}"
          origin = tweet.link.gsub(/^http.*com\//,"").gsub(/\/statuses\/\d*/,"")
          message = tweet.title.gsub(/#sor09/i, "")
          if origin.size + message.size  <= 135
            twitter.status(:post, "RT @#{origin}: #{message}")
          else
            twitter.status(:post, "RT @#{origin} tagged 'sor09':
  #{tweet.link}")
          end
          #, tweet.link.gsub(/^http.*statuses\//, ""))
          puts "#{Time.now.to_s(:long)}"
          tweet.update_attribute(:tweeted, true)
        end
      end
  rescue
  end
    sleep(60)
  end
end

feed_thread.join
