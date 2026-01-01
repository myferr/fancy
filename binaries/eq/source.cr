def print_usage
  STDERR.puts "\e[36m[i] Usage: eq EXPR <expression> THEN <then_command> [args...]\e[0m"
  STDERR.puts "\e[36m[i] Example: eq EXPR \"$USERNAME == 'dennis' && 1+1 == 2\" THEN out \"Yes\"\e[0m"
end

expr_idx = ARGV.index("EXPR")
then_idx = ARGV.index("THEN")

if expr_idx.nil? || then_idx.nil? || expr_idx >= then_idx
  print_usage
  exit 1
end

expr_tokens = ARGV[(expr_idx + 1)...then_idx]
then_tokens = ARGV[(then_idx + 1)..-1]

if expr_tokens.empty? || then_tokens.empty?
  print_usage
  exit 1
end

expression = expr_tokens.join(" ").strip
then_command = then_tokens[0]
then_args = then_tokens[1..-1]

def eval_expression_shell(expr : String) : Bool
  status = Process.run("bash", ["-c", expr],
    output: Process::Redirect::Inherit,
    error: Process::Redirect::Inherit)
  status.exit_code == 0
end

if eval_expression_shell(expression)
  if then_command == "out"
    puts then_args.join(" ")
  else
    system("#{then_command} #{then_args.join(" ")}")
  end
end
