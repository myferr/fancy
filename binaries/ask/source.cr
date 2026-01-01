def ask(prompt : String, default : String? = nil, secret : Bool = false) : String
  if default
    print "\e[36m[?] #{prompt} [#{default}]: \e[0m"
  else
    print "\e[36m[?] #{prompt}: \e[0m"
  end
  
  if secret
    # For secret input, we can't hide it in Crystal easily without external libs
    # Just read normally for now
    response = gets
  else
    response = gets
  end
  
  if response.nil? || response.strip.empty?
    if default
      return default
    else
      STDERR.puts "\e[31m[✗] No input provided and no default set\e[0m"
      exit 1
    end
  end
  
  response.strip
end

if ARGV.empty?
  STDERR.puts "\e[36m[i] Usage: ask <prompt> [--default <value>] [--secret]\e[0m"
  STDERR.puts "\e[36m[i] Prompts user for input interactively\e[0m"
  exit 1
end

prompt = ARGV[0]
default = nil
secret = false

i = 1
while i < ARGV.size
  case ARGV[i]
  when "--default", "-d"
    if i + 1 < ARGV.size
      default = ARGV[i + 1]
      i += 2
    else
      STDERR.puts "\e[31m[✗] --default requires a value\e[0m"
      exit 1
    end
  when "--secret", "-s"
    secret = true
    i += 1
  else
    STDERR.puts "\e[31m[✗] Unknown option: #{ARGV[i]}\e[0m"
    exit 1
  end
end

response = ask(prompt, default, secret)
puts response

