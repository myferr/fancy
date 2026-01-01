def hello_world(output, code = nil)
  case code
  when nil, ""
    puts output
  when "0"
    puts output
  when "1"
    puts "\e[32m[✓] #{output}\e[0m"
  when "2"
    puts "\e[31m[✳︎] #{output}\e[0m"
  when "3"
    puts "\e[33m[!] #{output}\e[0m"
  when "4"
    puts "\e[36m[i] #{output}\e[0m"
  else
    STDERR.puts "\e[31m[✗] Error: invalid code '#{code}' (use 0, 1, 2, 3, or 4)\e[0m \n\nCode 1: Success\nCode 2: Error\nCode 3: Warning\nCode 4: Information"
    exit 1
  end
end

hello_world(ARGV[0], ARGV[1])