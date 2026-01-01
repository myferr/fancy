require "json"

def dump_env_vars
  puts "\e[36m[=== Environment Variables ===]\e[0m"
  ENV.each do |key, value|
    puts "#{key}=#{value}"
  end
end

def dump_system_info
  puts "\e[36m[=== System Info ===]\e[0m"
  puts "Hostname: #{ENV["HOSTNAME"]? || ENV["COMPUTERNAME"]? || "unknown"}"
  puts "User: #{ENV["USER"]? || ENV["USERNAME"]? || "unknown"}"
  puts "Home: #{ENV["HOME"]? || ENV["USERPROFILE"]? || "unknown"}"
  puts "PWD: #{Dir.current}"
end

def dump_config(file_path : String)
  unless File.exists?(file_path)
    STDERR.puts "\e[31m[✗] Config file not found: #{file_path}\e[0m"
    return
  end
  
  puts "\e[36m[=== Config: #{file_path} ===]\e[0m"
  content = File.read(file_path)
  
  # Try to parse as JSON
  begin
    json = JSON.parse(content)
    puts json.to_pretty_json
  rescue
    # Not JSON, just print as-is
    puts content
  end
end

if ARGV.empty?
  dump_system_info
  puts
  dump_env_vars
else
  ARGV.each do |arg|
    case arg
    when "--env", "-e"
      dump_env_vars
    when "--system", "-s"
      dump_system_info
    when "--config", "-c"
      if ARGV.size > ARGV.index(arg).not_nil! + 1
        config_file = ARGV[ARGV.index(arg).not_nil! + 1]
        dump_config(config_file)
      else
        STDERR.puts "\e[31m[✗] --config requires a file path\e[0m"
        exit 1
      end
    else
      if arg.starts_with?("--")
        STDERR.puts "\e[31m[✗] Unknown option: #{arg}\e[0m"
        exit 1
      else
        dump_config(arg)
      end
    end
  end
end

