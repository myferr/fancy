require "file_utils"

if ARGV.empty?
  STDERR.puts "\e[36m[i] Usage: touchup <path1> [path2] [path3] ...\e[0m"
  STDERR.puts "\e[36m[i] Creates files or directories if they don't exist\e[0m"
  exit 1
end

ARGV.each do |path|
  if File.exists?(path)
    next
  end
  
  if path.ends_with?("/") || path.ends_with?("\\")
    # Directory path
    FileUtils.mkdir_p(path)
    puts "\e[32m[✓] Created directory: #{path}\e[0m"
  else
    # File path - create parent directory and file
    parent_dir = File.dirname(path)
    if !parent_dir.empty? && parent_dir != "."
      FileUtils.mkdir_p(parent_dir)
    end
    File.touch(path)
    puts "\e[32m[✓] Created file: #{path}\e[0m"
  end
end

