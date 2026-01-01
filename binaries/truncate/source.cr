require "file_utils"

def truncate_file(file_path : String, backup : Bool = false)
  unless File.exists?(file_path)
    STDERR.puts "\e[31m[✗] File not found: #{file_path}\e[0m"
    exit 1
  end
  
  if File.directory?(file_path)
    STDERR.puts "\e[31m[✗] Cannot truncate directory: #{file_path}\e[0m"
    exit 1
  end
  
  if backup
    backup_path = "#{file_path}.bak"
    FileUtils.cp(file_path, backup_path)
    puts "\e[32m[✓] Backup created: #{backup_path}\e[0m"
  end
  
  # Truncate file by opening in write mode
  File.open(file_path, "w") do |file|
    # File is now empty
  end
  
  puts "\e[32m[✓] Truncated: #{file_path}\e[0m"
end

if ARGV.empty?
  STDERR.puts "\e[36m[i] Usage: truncate <file> [--backup]\e[0m"
  STDERR.puts "\e[36m[i] Safely truncates a file, optionally creating a backup\e[0m"
  STDERR.puts "\e[36m[i] Example: truncate logs/app.log --backup\e[0m"
  exit 1
end

file_path = nil
backup = false

ARGV.each do |arg|
  case arg
  when "--backup", "-b"
    backup = true
  else
    file_path = arg unless arg.starts_with?("--")
  end
end

unless file_path
  STDERR.puts "\e[31m[✗] No file specified\e[0m"
  exit 1
end

truncate_file(file_path, backup)

