require_relative "evaluator"
require_relative "operator"

class CLI
  def initialize
    @evaluator = Evaluator.new
    @evaluator.append Operator.new(:+, 2)
    @evaluator.append Operator.new(:-, 2)
    @evaluator.append Operator.new(:*, 2)
    @evaluator.append Operator.new(:/, 2)
  end

  def stack
    @stack ||= []
  end

  def handle_token
    begin
      token = yield
      if token.match(/\A\s*-?[0-9]+(\.[0-9]+)?\s*\z/)
        token = token.to_f
        token = token.to_i if (token % 1.0).zero?
        stack.push(token)
        $stdout.puts token
      elsif @evaluator.operator?(token)
        @evaluator.evaluate(token, stack)
        $stdout.puts stack.last
      elsif 'q' == token
        return false
      else
        raise ArgumentError, "'#{token}' is not a valid input"
      end
    rescue ArgumentError => e
      $stdout.puts e.message
    rescue Interrupt
      return false
    rescue => e
      $stdout.puts e.message
      $stdout.puts e.backtrace
    end
    return true
  end

  def next_token
    handle_token do
      $stdout.print "> "
      $stdin.gets.chomp
    end
  end

  def run
    $stdout.puts "Enter 'q' to exit"
    begin; end while next_token
  end
end
