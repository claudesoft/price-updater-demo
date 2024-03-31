require 'httparty'
require 'haml'

# Methode zum Abrufen der Preise
def fetch_price(chain_id, pair_address)
  url = "https://api.dexscreener.com/latest/dex/pairs/#{chain_id}/#{pair_address}"
  response = HTTParty.get(url)
  if response.success?
    data = response.parsed_response["pairs"].first
    price_usd = data["priceUsd"]
    price_usd
  else
    "N/A"
  end
end

# Preise abrufen
eth_price = fetch_price('ethereum', '0x88e6a0c2ddd26feeb64f039a2c41296fcb3f5640')
cake_price = fetch_price('bsc', '0x7f51c8aaa6b0599abd16674e2b17fec7a9f674a1')
avax_price = fetch_price('avalanche', '0xf4003f4efbe8691b60249e6afbd307abe7758adb')

# HAML-Template rendern
#template = File.read('template.haml')
#puts template
engine = Haml::Template.new('template.haml')
output = engine.render(Object.new, eth_price: eth_price, cake_price: cake_price, avax_price: avax_price)

# Ausgabe in index.html schreiben
File.open("index.html", "w") do |file|
  file.puts output
end
