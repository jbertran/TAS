Dir.entries(".").each do |file|
  p file
  if /.*.c$/ =~ file
    result = `../analyzer.byte -interval #{file}`
    begin
      res_file = File.open("result-interval/#{file}.txt", "r").read
      puts "#{result}"
      puts "Results:"
      puts "#{res_file}"
    rescue
    end
  end
  puts ""
end
