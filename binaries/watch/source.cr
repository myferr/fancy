require "process"

if ARGV.size < 2
  STDERR.puts "\e[36m[i] Usage: watch <path> <command> [args...]\e[0m"
  STDERR.puts "\e[36m[i] Watches a file/directory and runs command on change\e[0m"
  STDERR.puts "\e[36m[i] Example: watch src/ 'echo changed'\e[0m"
  exit 1
end

watch_path = ARGV[0]
command = ARGV[1]
command_args = ARGV[2..-1]

unless File.exists?(watch_path)
  STDERR.puts "\e[31m[✗] Path not found: #{watch_path}\e[0m"
  exit 1
end

last_mtime = File.info(watch_path).modification_time

puts "\e[36m[i] Watching: #{watch_path}\e[0m"
puts "\e[36m[i] Command: #{command} #{command_args.join(" ")}\e[0m"
puts "\e[36m[i] Press Ctrl+C to stop\e[0m"

loop do
  sleep 1.second
  
  begin
    current_mtime = File.info(watch_path).modification_time
    if current_mtime > last_mtime
      puts "\e[33m[!] Change detected, running command...\e[0m"
      
      full_command = command
      if !command_args.empty?
        full_command = "#{command} #{command_args.join(" ")}"
      end
      
      Process.run("/bin/sh", ["-c", full_command])
      
      last_mtime = current_mtime
    end
  rescue
    # File might have been deleted, check if it exists
    unless File.exists?(watch_path)
      STDERR.puts "\e[31m[✗] Watched path no longer exists\e[0m"
      exit 1
    end
  end
end

