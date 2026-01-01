def print_usage
  STDERR.puts "\e[36m[i] Usage: new <filename>             # create a new file\e[0m"
  STDERR.puts "\e[36m[i]        new -d <dirname>           # create a new directory\e[0m"
  STDERR.puts "\e[36m[i]        new --directory <dirname>\e[0m"
end

def error(msg)
  STDERR.puts "\e[31m[✗] #{msg}\e[0m"
  exit 1
end

if ARGV.empty?
  print_usage
  exit 1
end

is_directory = false
filename = nil

if ARGV[0] == "-d" || ARGV[0] == "--directory"
  is_directory = true
  filename = ARGV[1]
elsif ARGV[0].start_with?("-")
  error "Unknown option '#{ARGV[0]}'"
else
  filename = ARGV[0]
end

if filename.nil? || filename.strip == ""
  error "No file or directory name provided."
end

if is_directory
  if File.exist?(filename)
    error "Directory or file '#{filename}' already exists."
  end
  Dir.mkdir(filename)
  puts "\e[32m[✓] Directory '#{filename}' created\e[0m"
else
  if File.exist?(filename)
    error "File or directory '#{filename}' already exists."
  end
  File.write(filename, "")
  puts "\e[32m[✓] File '#{filename}' created\e[0m"
end
