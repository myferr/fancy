def set_env_var(name : String, value : String)
  ENV[name] = value
  puts "\e[32m[✓] Set #{name}=#{value}\e[0m"
end

def check_env_var(name : String) : Bool
  value = ENV[name]?
  if value
    puts "\e[32m[✓] #{name} is set\e[0m"
    true
  else
    STDERR.puts "\e[31m[✗] #{name} is not set\e[0m"
    false
  end
end

if ARGV.size < 2
  STDERR.puts "\e[36m[i] Usage:\e[0m"
  STDERR.puts "\e[36m[i]   envset check <var1> [var2] ...\e[0m"
  STDERR.puts "\e[36m[i]   envset set <var> <value>\e[0m"
  exit 1
end

command = ARGV[0]

case command
when "check"
  all_set = true
  ARGV[1..-1].each do |var|
    all_set = false unless check_env_var(var)
  end
  exit all_set ? 0 : 1
when "set"
  if ARGV.size < 3
    STDERR.puts "\e[31m[✗] Usage: envset set <var> <value>\e[0m"
    exit 1
  end
  set_env_var(ARGV[1], ARGV[2])
else
  STDERR.puts "\e[31m[✗] Unknown command: #{command} (use 'check' or 'set')\e[0m"
  exit 1
end

