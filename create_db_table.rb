require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :username => "root",
  :host => "127.0.0.1",
  :password => "",
  :database => "twibot"
)

ActiveRecord::Schema.define do
  create_table(:tweets, :force => true) do |t|
    t.string      :twitter_id
    t.datetime    :published
    t.string      :link
    t.string      :title
    t.string      :content
    t.string      :author_name
    t.string      :author_uri
    t.boolean     :tweeted
  end
end
