require_relative "operator"

class Evaluator
  def append(operator)
    raise ArgumentError, "The argument to #{self.class.to_s}#append must be an Operator" unless operator.is_a?(Operator)
    operators[operator.symbol] = operator
  end

  def evaluate(symbol, stack)
    raise ArgumentError, "No #{symbol} operator is defined" unless operator?(symbol)
    operator =  self[symbol.to_sym]
    raise ArgumentError, "The #{symbol} operator requires #{operator.argument_count} arguments.  Only #{stack.size} arguments were given" if stack.size < operator.argument_count
    result = operator.evaluate(*stack.pop(operator.argument_count).collect(&:to_f))
    result = result.to_i if (result % 1).zero?
    stack.push(result)
  end

  def operator?(symbol)
    operators.key?(symbol.to_sym)
  end

  private
  def [](symbol)
    operators[symbol]
  end

  def operators
    @operators ||= {}
  end
end
