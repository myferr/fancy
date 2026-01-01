if ARGV.size != 1
  STDERR.puts "\e[36m[i] Usage: ensure <file_path>\e[0m"
  exit 2
end

file_path = ARGV[0]
unless File.exists?(file_path)
  STDERR.puts "\e[31m[!] File does not exist: #{file_path}\e[0m"
  exit 1
end
