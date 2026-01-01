require "process"

def check_disk(path : String) : Float64
  process = Process.new("df", ["-k", path], output: Process::Redirect::Pipe)
  output = process.output.gets_to_end
  process.wait
  lines = output.split("\n")
  return 0.0 if lines.size < 2
  
  # Parse df output: Filesystem 1024-blocks Used Available Capacity Mounted
  parts = lines[1].split(/\s+/)
  return 0.0 if parts.size < 5
  
  capacity_str = parts[4].chomp("%")
  capacity_str.to_f? || 0.0
end

def check_cpu() : Float64
  process = Process.new("top", ["-l", "1"], output: Process::Redirect::Pipe, error: Process::Redirect::Close)
  output = process.output.gets_to_end
  process.wait
  
  # Try to extract CPU usage from top output
  if output =~ /CPU usage:\s*(\d+\.\d+)%/
    $1.to_f? || 0.0
  else
    0.0
  end
end

def check_process(name : String) : Bool
  result = Process.run("pgrep", ["-f", name], output: Process::Redirect::Close, error: Process::Redirect::Close)
  result.exit_code == 0
end

def check_file(path : String) : Bool
  File.exists?(path)
end

def parse_threshold(threshold_str : String) : Float64
  threshold_str.chomp("%").to_f? || 0.0
end

if ARGV.size < 2
  STDERR.puts "\e[36m[i] Usage: monitor <resource_type> <target> [--warn <threshold>] [--then <command> [args...]]\e[0m"
  STDERR.puts "\e[36m[i] Resource types: disk, cpu, process, file\e[0m"
  STDERR.puts "\e[36m[i] Example: monitor disk / --warn 80% --then out \"Disk almost full\"\e[0m"
  exit 1
end

resource_type = ARGV[0].downcase
target = ARGV[1]

warn_idx = ARGV.index("--warn")
then_idx = ARGV.index("--then")

warn_threshold = nil
if warn_idx && warn_idx + 1 < ARGV.size
  warn_threshold = parse_threshold(ARGV[warn_idx + 1])
end

then_command = nil
then_args = [] of String
if then_idx && then_idx + 1 < ARGV.size
  then_command = ARGV[then_idx + 1]
  then_args = ARGV[(then_idx + 2)..-1]
end

puts "\e[36m[i] Monitoring #{resource_type}: #{target}\e[0m"
if warn_threshold
  puts "\e[36m[i] Warning threshold: #{warn_threshold}%\e[0m"
end
puts "\e[36m[i] Press Ctrl+C to stop\e[0m"

loop do
  sleep 1.second
  
  case resource_type
  when "disk"
    usage = check_disk(target)
    if warn_threshold && usage >= warn_threshold
      STDERR.puts "\e[33m[!] Disk usage warning: #{usage}%\e[0m"
      if then_command
        Process.run("/bin/sh", ["-c", "#{then_command} #{then_args.join(" ")}"])
      end
    end
  when "cpu"
    usage = check_cpu()
    if warn_threshold && usage >= warn_threshold
      STDERR.puts "\e[33m[!] CPU usage warning: #{usage}%\e[0m"
      if then_command
        Process.run("/bin/sh", ["-c", "#{then_command} #{then_args.join(" ")}"])
      end
    end
  when "process"
    exists = check_process(target)
    unless exists
      STDERR.puts "\e[33m[!] Process not running: #{target}\e[0m"
      if then_command
        Process.run("/bin/sh", ["-c", "#{then_command} #{then_args.join(" ")}"])
      end
    end
  when "file"
    exists = check_file(target)
    unless exists
      STDERR.puts "\e[33m[!] File not found: #{target}\e[0m"
      if then_command
        Process.run("/bin/sh", ["-c", "#{then_command} #{then_args.join(" ")}"])
      end
    end
  else
    STDERR.puts "\e[31m[✗] Unknown resource type: #{resource_type}\e[0m"
    exit 1
  end
end

