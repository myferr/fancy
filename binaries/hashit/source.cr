require "digest/sha256"
require "digest/md5"

def compute_hash(file_path : String, algorithm : String = "sha256") : String
  content = File.read(file_path)
  case algorithm.downcase
  when "sha256", "sha"
    Digest::SHA256.hexdigest(content)
  when "md5"
    Digest::MD5.hexdigest(content)
  else
    STDERR.puts "\e[31m[✗] Unknown algorithm: #{algorithm} (use sha256 or md5)\e[0m"
    exit 1
  end
end

algorithm = "sha256"
files = [] of String

i = 0
while i < ARGV.size
  case ARGV[i]
  when "--algorithm", "-a", "--algo"
    if i + 1 < ARGV.size
      algorithm = ARGV[i + 1]
      i += 2
    else
      STDERR.puts "\e[31m[✗] --algorithm requires a value\e[0m"
      exit 1
    end
  when "--md5", "-m"
    algorithm = "md5"
    i += 1
  else
    files << ARGV[i]
    i += 1
  end
end

if files.empty?
  STDERR.puts "\e[36m[i] Usage: hashit [--algorithm sha256|md5] <file1> [file2] ...\e[0m"
  STDERR.puts "\e[36m[i] Computes checksums for files\e[0m"
  exit 1
end

files.each do |file_path|
  unless File.exists?(file_path)
    STDERR.puts "\e[31m[✗] File not found: #{file_path}\e[0m"
    next
  end
  
  hash = compute_hash(file_path, algorithm)
  puts "#{hash}  #{file_path}"
end

