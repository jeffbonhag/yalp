require 'dotenv'
require 'json/pure'
require 'yelp'
require 'vcardigan'

Dotenv.load

Yelp.client.configure do |config|
  config.consumer_key = ENV['CONSUMER_KEY']
  config.consumer_secret = ENV['CONSUMER_SECRET']
  config.token = ENV['TOKEN']
  config.token_secret = ENV['TOKEN_SECRET']
end

def find_total(query)
  Yelp.client.search(query).total
end

def find_phone_numbers(query, offset)
  results = Yelp.client.search(query, {offset: offset})
  results.businesses.each do |business|
    begin
      vcard = VCardigan.create
      vcard.fn business.name
      vcard.tel business.phone, :type => 'WORK'
      puts vcard
    rescue NoMethodError
    end
  end
end


query = ARGV[0] or raise "No query specified"
total = find_total(query)
(0..total).step(20) do |offset|
  find_phone_numbers(query, offset)
end

