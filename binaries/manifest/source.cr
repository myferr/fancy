if ARGV.empty?
  STDERR.puts "\e[36m[i] Usage: manifest <file1> [file2] [file3] ...\e[0m"
  STDERR.puts "\e[36m[i] Verifies that all listed files exist\e[0m"
  exit 1
end

missing_files = [] of String
existing_files = [] of String

ARGV.each do |file_path|
  if File.exists?(file_path)
    existing_files << file_path
  else
    missing_files << file_path
  end
end

if missing_files.empty?
  puts "\e[32m[✓] All #{existing_files.size} file(s) verified\e[0m"
  existing_files.each { |f| puts "  ✓ #{f}" }
  exit 0
else
  STDERR.puts "\e[31m[✗] Missing #{missing_files.size} file(s):\e[0m"
  missing_files.each { |f| STDERR.puts "  ✗ #{f}" }
  if !existing_files.empty?
    STDERR.puts "\e[33m[!] Found #{existing_files.size} file(s):\e[0m"
    existing_files.each { |f| STDERR.puts "  ✓ #{f}" }
  end
  exit 1
end

