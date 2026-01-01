#!/usr/bin/env ruby

require 'fileutils'

source_file = nil
output_file = nil

ARGV.each_with_index do |arg, i|
  if arg == '-o' && ARGV[i + 1]
    output_file = ARGV[i + 1]
  elsif arg.end_with?('.rb') && source_file.nil?
    source_file = arg
  end
end

source_file ||= 'source.rb'
output_file ||= 'out'

unless File.exist?(source_file)
  STDERR.puts "Error: Source file '#{source_file}' not found"
  exit 1
end

puts "Checking syntax..."
syntax_check = `ruby -c "#{source_file}" 2>&1`
unless $?.success?
  STDERR.puts "Syntax error:"
  STDERR.puts syntax_check
  exit 1
end
puts "✓ Syntax OK"

source_content = File.read(source_file)

puts "Creating executable..."
executable_content = "#!/usr/bin/env ruby\n\n#{source_content}"

File.write(output_file, executable_content)
FileUtils.chmod('+x', output_file)

puts "✓ Compiled successfully: #{output_file}"
puts "  Run with: ./#{output_file}"

