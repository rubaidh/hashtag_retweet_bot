require 'rubygems'
require 'feedzirra' # feed helper

feed = Feedzirra::Feed.fetch_and_parse("http://search.twitter.com/search.atom?q=+%23sor09")

feed.entries.each do |entry|

  puts "entry #{entry.inspect}"

end
