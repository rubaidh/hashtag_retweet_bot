require 'twibot'

# Receive messages, and tweet them publicly
#
message do |message, params|
  post_tweet message
end

# Respond to @replies if they come from the right crowd
#
reply :from => [:cjno, :irbno] do |message, params|
  post_tweet "@#{message.sender.screen_name} I agree"
end

# Listen in and log tweets
#
tweet do |message, params|
  MyApp.log_tweet(message)
end
