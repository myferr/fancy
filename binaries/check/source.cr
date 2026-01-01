require "process"

def check_binary(name : String) : Bool
  result = Process.run("which", [name], output: Process::Redirect::Null, error: Process::Redirect::Null)
  if result.exit_code == 0
    puts "\e[32m[✓] Binary found: #{name}\e[0m"
    true
  else
    STDERR.puts "\e[31m[✗] Binary not found: #{name}\e[0m"
    false
  end
end

def check_env_var(name : String) : Bool
  value = ENV[name]?
  if value
    puts "\e[32m[✓] Environment variable set: #{name}\e[0m"
    true
  else
    STDERR.puts "\e[31m[✗] Environment variable not set: #{name}\e[0m"
    false
  end
end

def check_file(path : String) : Bool
  if File.exists?(path)
    puts "\e[32m[✓] File exists: #{path}\e[0m"
    true
  else
    STDERR.puts "\e[31m[✗] File not found: #{path}\e[0m"
    false
  end
end

if ARGV.empty?
  STDERR.puts "\e[36m[i] Usage: check [--binary <name>] [--env <var>] [--file <path>]\e[0m"
  STDERR.puts "\e[36m[i] Example: check --binary ruby --env HOME --file config.json\e[0m"
  exit 1
end

all_passed = true
i = 0

while i < ARGV.size
  case ARGV[i]
  when "--binary", "-b"
    if i + 1 < ARGV.size
      all_passed = false unless check_binary(ARGV[i + 1])
      i += 2
    else
      STDERR.puts "\e[31m[✗] --binary requires a name\e[0m"
      exit 1
    end
  when "--env", "-e"
    if i + 1 < ARGV.size
      all_passed = false unless check_env_var(ARGV[i + 1])
      i += 2
    else
      STDERR.puts "\e[31m[✗] --env requires a variable name\e[0m"
      exit 1
    end
  when "--file", "-f"
    if i + 1 < ARGV.size
      all_passed = false unless check_file(ARGV[i + 1])
      i += 2
    else
      STDERR.puts "\e[31m[✗] --file requires a path\e[0m"
      exit 1
    end
  else
    STDERR.puts "\e[31m[✗] Unknown option: #{ARGV[i]}\e[0m"
    exit 1
  end
end

exit all_passed ? 0 : 1

