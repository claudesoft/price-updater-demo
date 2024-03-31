require 'httparty'
require 'haml'

# Methode zum Abrufen der Preise und FDV
def fetch_token_data(chain_id, pair_address)
  url = "https://api.dexscreener.com/latest/dex/pairs/#{chain_id}/#{pair_address}"
  response = HTTParty.get(url)
  if response.success?
    data = response.parsed_response["pairs"].first
    price_usd = data["priceUsd"]
    fdv = data["fdv"].to_f # Konvertierung in Float für mathematische Operationen
    { price_usd: price_usd, fdv: fdv }
  else
    { price_usd: "N/A", fdv: 0.0 }
  end
end

# FDV-Prozentberechnungsfunktion
def calculate_fdv_percentage(data_array)
  fdv_values = data_array.map { |data| data[:fdv] }
  min_fdv = fdv_values.min
  max_fdv = fdv_values.max
  range = max_fdv - min_fdv
  data_array.each do |data|
    # Vermeidung einer Division durch Null, falls alle FDV-Werte gleich sind
    if range > 0
      data[:fdv_percentage] = ((data[:fdv] - min_fdv) / range * 100).round(2)
    else
      data[:fdv_percentage] = 0.0
    end
  end
end

# Token-Daten abrufen
eth_data = fetch_token_data('ethereum', '0x88e6a0c2ddd26feeb64f039a2c41296fcb3f5640')
cake_data = fetch_token_data('bsc', '0x7f51c8aaa6b0599abd16674e2b17fec7a9f674a1')
avax_data = fetch_token_data('avalanche', '0xf4003f4efbe8691b60249e6afbd307abe7758adb')

token_data_array = [eth_data, cake_data, avax_data]

# FDV-Prozentwerte berechnen
calculate_fdv_percentage(token_data_array)

# HAML-Template rendern und Ausgabe in index.html schreiben
engine = Haml::Template.new("template.haml")

output = engine.render(Object.new, eth_data: eth_data, cake_data: cake_data, avax_data: avax_data)

File.open("index.html", "w") do |file|
  file.puts output
end
