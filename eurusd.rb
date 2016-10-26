require 'date'

OHLC = { "OPEN"  => "Open",
         "HIGH"  => "High",
         "LOW"   => "Low",
         "CLOSE" => "Close"}

def get_daily_prices(type)
  
  data = open('EURUSD.csv')

  prices = data.map do |line|
    line_items = line.chomp.split(",")
    case type
    when "OPEN"
      price = line_items[3].to_f
    when "HIGH"
      price = line_items[5].to_f
    when "LOW"
      price = line_items[4].to_f
    when "CLOSE"
      price = line_items[6].to_f
    else
      puts "Nope"
    end
  end
  # puts prices
  return prices
end

def mean(array)
  total = array.inject(0){ |sum, x| sum += x }
  return total.to_f / array.length
end

def median(array)
  array.sort!
  if array.length % 2 == 1
    return array[array.length/2]
  else
    item1 = array[array.length/2 - 1]
    item2 = array[array.length/2]
    return mean([item1, item2])
  end
end

def retrieve_and_calculate_stats
  stats = {}
  OHLC.each do |type, label|
    prices = get_daily_prices(type)
    stats[label] = { mean: mean(prices),
                       median: median(prices) }
  end
  return stats
end

def output_stats_to_table(stats={})
  puts
  puts "----------------------------------------"
  puts "| Type       | Mean       | Median     |"
  puts "----------------------------------------"
  stats.each do |label, price|
    print "| " + label.ljust(10) + " | "
    print sprintf("%.6f", price[:mean]).rjust(10) + " | "
    puts sprintf("%.6f", price[:median]).rjust(10) + " |"
  end
  puts "----------------------------------------"
  puts
end

stats = retrieve_and_calculate_stats
output_stats_to_table(stats)
