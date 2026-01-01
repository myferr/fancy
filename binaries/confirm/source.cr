def confirm(prompt : String, default : Bool = false) : Bool
  default_text = default ? "[Y/n]" : "[y/N]"
  print "\e[36m[?] #{prompt} #{default_text}: \e[0m"
  
  response = gets
  return default if response.nil?
  
  response = response.strip.downcase
  
  if response.empty?
    return default
  elsif response == "y" || response == "yes"
    return true
  elsif response == "n" || response == "no"
    return false
  else
    # Invalid input, use default
    return default
  end
end

prompt = ARGV[0]? || "Continue?"
default_yes = ARGV.includes?("--yes") || ARGV.includes?("-y")
default_no = ARGV.includes?("--no") || ARGV.includes?("-n")

default = default_yes || !default_no

result = confirm(prompt, default)
exit result ? 0 : 1

