require "file_utils"

if ARGV.empty?
  STDERR.puts "\e[36m[i] Usage: clean <pattern1> [pattern2] ...\e[0m"
  STDERR.puts "\e[36m[i] Removes files/directories matching patterns\e[0m"
  STDERR.puts "\e[36m[i] Example: clean '*.tmp' 'build/' '.cache'\e[0m"
  exit 1
end

removed_count = 0

ARGV.each do |pattern|
  if File.exists?(pattern)
    if File.directory?(pattern)
      FileUtils.rm_rf(pattern)
      puts "\e[32m[✓] Removed directory: #{pattern}\e[0m"
      removed_count += 1
    else
      File.delete(pattern)
      puts "\e[32m[✓] Removed file: #{pattern}\e[0m"
      removed_count += 1
    end
  else
    # Try glob pattern
    Dir.glob(pattern).each do |path|
      if File.directory?(path)
        FileUtils.rm_rf(path)
        puts "\e[32m[✓] Removed directory: #{path}\e[0m"
        removed_count += 1
      else
        File.delete(path)
        puts "\e[32m[✓] Removed file: #{path}\e[0m"
        removed_count += 1
      end
    end
  end
end

if removed_count == 0
  puts "\e[33m[!] No files or directories removed\e[0m"
else
  puts "\e[36m[i] Removed #{removed_count} item(s)\e[0m"
end

