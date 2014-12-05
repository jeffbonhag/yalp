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

def find_total
  Yelp.client.search('New Paltz').total
end

def find_new_paltz_phone_numbers(offset)
  results = Yelp.client.search('New Paltz', {offset: offset})
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


total = find_total
(0..total).step(20) do |offset|
  find_new_paltz_phone_numbers(offset)
end

