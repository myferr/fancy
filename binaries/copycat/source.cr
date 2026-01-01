require "file_utils"

def copy_file(source : String, dest : String, overwrite : Bool = false)
  unless File.exists?(source)
    STDERR.puts "\e[33m[!] Source file does not exist: #{source}\e[0m"
    return false
  end
  
  if File.exists?(dest) && !overwrite
    STDERR.puts "\e[33m[!] Destination exists (use --overwrite): #{dest}\e[0m"
    return false
  end
  
  # Create parent directory if needed
  parent_dir = File.dirname(dest)
  if !parent_dir.empty? && parent_dir != "."
    FileUtils.mkdir_p(parent_dir)
  end
  
  FileUtils.cp(source, dest)
  puts "\e[32m[✓] Copied: #{source} -> #{dest}\e[0m"
  true
end

overwrite = false
sources = [] of String
dest = ""

i = 0
while i < ARGV.size
  case ARGV[i]
  when "--overwrite", "-f"
    overwrite = true
    i += 1
  else
    if sources.empty? && i < ARGV.size - 1
      sources << ARGV[i]
      i += 1
    else
      dest = ARGV[i]
      i += 1
    end
  end
end

if sources.empty? || dest.empty?
  STDERR.puts "\e[36m[i] Usage: copycat [--overwrite] <source> <dest>\e[0m"
  STDERR.puts "\e[36m[i] Copies file if source exists\e[0m"
  exit 1
end

if sources.size == 1
  success = copy_file(sources[0], dest, overwrite)
  exit success ? 0 : 1
else
  # Multiple sources, dest must be a directory
  unless File.directory?(dest)
    STDERR.puts "\e[31m[✗] Destination must be a directory when copying multiple files\e[0m"
    exit 1
  end
  
  all_success = true
  sources.each do |source|
    filename = File.basename(source)
    target = File.join(dest, filename)
    success = copy_file(source, target, overwrite)
    all_success = false unless success
  end
  exit all_success ? 0 : 1
end

