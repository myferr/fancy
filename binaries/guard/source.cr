def validate_path(path : String, must_exist : Bool = true) : Bool
  if must_exist && !File.exists?(path)
    STDERR.puts "\e[31m[✗] Required path missing: #{path}\e[0m"
    return false
  end
  
  if File.exists?(path) && File.directory?(path)
    puts "\e[32m[✓] Directory exists: #{path}\e[0m"
  elsif File.exists?(path)
    puts "\e[32m[✓] File exists: #{path}\e[0m"
  else
    puts "\e[33m[!] Path does not exist: #{path}\e[0m"
  end
  
  true
end

def validate_structure(base_path : String, required_paths : Array(String))
  puts "\e[36m[i] Validating structure in: #{base_path}\e[0m"
  
  all_valid = true
  required_paths.each do |rel_path|
    full_path = File.join(base_path, rel_path)
    unless File.exists?(full_path)
      STDERR.puts "\e[31m[✗] Missing: #{rel_path}\e[0m"
      all_valid = false
    else
      puts "\e[32m[✓] Found: #{rel_path}\e[0m"
    end
  end
  
  all_valid
end

if ARGV.size < 2
  STDERR.puts "\e[36m[i] Usage:\e[0m"
  STDERR.puts "\e[36m[i]   guard path <path1> [path2] ...\e[0m"
  STDERR.puts "\e[36m[i]   guard structure <base_path> <path1> [path2] ...\e[0m"
  exit 1
end

command = ARGV[0]

case command
when "path"
  all_valid = true
  ARGV[1..-1].each do |path|
    all_valid = false unless validate_path(path)
  end
  exit all_valid ? 0 : 1
when "structure"
  if ARGV.size < 3
    STDERR.puts "\e[31m[✗] Usage: guard structure <base_path> <path1> [path2] ...\e[0m"
    exit 1
  end
  base_path = ARGV[1]
  required_paths = ARGV[2..-1]
  all_valid = validate_structure(base_path, required_paths)
  exit all_valid ? 0 : 1
else
  STDERR.puts "\e[31m[✗] Unknown command: #{command} (use 'path' or 'structure')\e[0m"
  exit 1
end

