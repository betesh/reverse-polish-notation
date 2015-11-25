class Operator
  attr_reader :symbol, :argument_count

  def initialize(symbol, argument_count)
    raise ArgumentError, "The first argument to #{self.class.to_s}.new must be a Symbol"  unless symbol.is_a?(Symbol)
    raise ArgumentError, "The second argument to #{self.class.to_s}.new must be a Fixnum" unless argument_count.is_a?(Fixnum)
    @symbol, @argument_count = symbol, argument_count
  end

  def evaluate(*args)
    raise ArgumentError, "The #{symbol} operator takes exactly #{argument_count} arguments, not #{args.size}" unless argument_count == args.size
    args.inject(&symbol)
  end
end
