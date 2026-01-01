def print_usage
  STDERR.puts "\e[36m[i] Usage: new <filename>             # create a new file\e[0m"
  STDERR.puts "\e[36m[i]        new -d <dirname>           # create a new directory\e[0m"
  STDERR.puts "\e[36m[i]        new --directory <dirname>\e[0m"
end

def error(msg : String)
  STDERR.puts "\e[31m[✗] #{msg}\e[0m"
  exit 1
end

if ARGV.empty?
  print_usage
  exit 1
end

is_directory = false
filename : String? = nil

if ARGV[0] == "-d" || ARGV[0] == "--directory"
  is_directory = true
  filename = ARGV[1]?
elsif ARGV[0].starts_with?('-')
  error "Unknown option '#{ARGV[0]}'"
else
  filename = ARGV[0]?
end

if filename.nil? || filename.try(&.strip).to_s.empty?
  error "No file or directory name provided."
end

# Safe "not nil" assertion below because above check ensures filename exists
name = filename.not_nil!

if is_directory
  if File.exists?(name)
    error "Directory or file '#{name}' already exists."
  end
  Dir.mkdir(name)
  puts "\e[32m[✓] Directory '#{name}' created\e[0m"
else
  if File.exists?(name)
    error "File or directory '#{name}' already exists."
  end
  File.write(name, "")
  puts "\e[32m[✓] File '#{name}' created\e[0m"
end
