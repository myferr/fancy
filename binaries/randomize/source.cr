def random_int(min : Int32, max : Int32) : Int32
  rand(min..max)
end

def random_float(min : Float64, max : Float64) : Float64
  min + rand * (max - min)
end

def random_string(length : Int32) : String
  chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  String.build(length) do |str|
    length.times do
      str << chars[rand(chars.size)]
    end
  end
end

def random_line_from_file(file_path : String) : String?
  unless File.exists?(file_path)
    STDERR.puts "\e[31m[✗] File not found: #{file_path}\e[0m"
    return nil
  end
  
  lines = File.read_lines(file_path)
  return nil if lines.empty?
  
  lines[rand(lines.size)]
end

if ARGV.empty?
  STDERR.puts "\e[36m[i] Usage:\e[0m"
  STDERR.puts "\e[36m[i]   randomize <min> <max>              - Random integer\e[0m"
  STDERR.puts "\e[36m[i]   randomize --float <min> <max>      - Random float\e[0m"
  STDERR.puts "\e[36m[i]   randomize --string <length>        - Random string\e[0m"
  STDERR.puts "\e[36m[i]   randomize --file <path>           - Random line from file\e[0m"
  STDERR.puts "\e[36m[i] Example: randomize 1 100\e[0m"
  STDERR.puts "\e[36m[i] Example: randomize --file names.txt\e[0m"
  exit 1
end

case ARGV[0]
when "--float", "-f"
  if ARGV.size < 3
    STDERR.puts "\e[31m[✗] --float requires min and max\e[0m"
    exit 1
  end
  min = ARGV[1].to_f? || 0.0
  max = ARGV[2].to_f? || 1.0
  puts random_float(min, max)
when "--string", "-s"
  if ARGV.size < 2
    STDERR.puts "\e[31m[✗] --string requires a length\e[0m"
    exit 1
  end
  length = ARGV[1].to_i? || 10
  puts random_string(length)
when "--file"
  if ARGV.size < 2
    STDERR.puts "\e[31m[✗] --file requires a file path\e[0m"
    exit 1
  end
  line = random_line_from_file(ARGV[1])
  if line
    puts line
  else
    exit 1
  end
else
  # Default: random integer
  if ARGV.size < 2
    STDERR.puts "\e[31m[✗] Requires min and max for random integer\e[0m"
    exit 1
  end
  min = ARGV[0].to_i? || 0
  max = ARGV[1].to_i? || 100
  puts random_int(min, max)
end

