require "process"

def parse_duration(duration_str : String) : Time::Span
  duration_str = duration_str.downcase
  
  if duration_str.ends_with?("s")
    seconds = duration_str.chomp("s").to_f? || 0.0
    seconds.seconds
  elsif duration_str.ends_with?("m")
    minutes = duration_str.chomp("m").to_f? || 0.0
    minutes.minutes
  elsif duration_str.ends_with?("h")
    hours = duration_str.chomp("h").to_f? || 0.0
    hours.hours
  elsif duration_str.ends_with?("ms")
    milliseconds = duration_str.chomp("ms").to_f? || 0.0
    milliseconds.milliseconds
  else
    # Try to parse as seconds
    seconds = duration_str.to_f? || 0.0
    seconds.seconds
  end
end

if ARGV.size < 2
  STDERR.puts "\e[36m[i] Usage: timer <duration> <command> [args...]\e[0m"
  STDERR.puts "\e[36m[i] Duration format: 10s, 5m, 1h, 500ms\e[0m"
  STDERR.puts "\e[36m[i] Example: timer 10s echo \"Time's up!\"\e[0m"
  STDERR.puts "\e[36m[i] For intervals, use: timer --interval <duration> <command> [args...]\e[0m"
  exit 1
end

interval_mode = ARGV.includes?("--interval") || ARGV.includes?("-i")
duration_str = nil
command = nil
command_args = [] of String

if interval_mode
  interval_idx = ARGV.index("--interval") || ARGV.index("-i")
  if interval_idx && interval_idx + 1 < ARGV.size
    duration_str = ARGV[interval_idx + 1]
    if interval_idx + 2 < ARGV.size
      command = ARGV[interval_idx + 2]
      command_args = ARGV[(interval_idx + 3)..-1]
    end
  end
else
  duration_str = ARGV[0]
  if ARGV.size > 1
    command = ARGV[1]
    command_args = ARGV[2..-1]
  end
end

unless duration_str && command
  STDERR.puts "\e[31m[✗] Invalid arguments\e[0m"
  exit 1
end

duration = parse_duration(duration_str)

if interval_mode
  puts "\e[36m[i] Running command every #{duration_str}\e[0m"
  puts "\e[36m[i] Press Ctrl+C to stop\e[0m"
  
  loop do
    sleep duration
    full_command = command
    if !command_args.empty?
      full_command = "#{command} #{command_args.join(" ")}"
    end
    Process.run("/bin/sh", ["-c", full_command])
  end
else
  puts "\e[36m[i] Waiting #{duration_str}...\e[0m"
  sleep duration
  
  full_command = command
  if !command_args.empty?
    full_command = "#{command} #{command_args.join(" ")}"
  end
  
  Process.run("/bin/sh", ["-c", full_command])
end

