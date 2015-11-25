require "evaluator"

describe Evaluator do
  let(:operator) { Operator.new(:!, 1) }

  before(:each) do
    subject.append(operator)
  end

  describe "#operator?" do
    it "should return true when passed a String whose Symbol matches the Operator" do
      expect(subject.operator?("!")).to eq(true)
    end

    it "should return true when passed a Symbol that matches the Operator" do
      expect(subject.operator?(:!)).to eq(true)
    end

    it "should return false when passed a String whose Symbol does not match any Operator" do
      expect(subject.operator?("+")).to eq(false)
    end

    it "should return true when passed a Symbol that does not match any Operator" do
      expect(subject.operator?(:+)).to eq(false)
    end
  end

  describe "#evaluate" do
    it "should raise an ArgumentError if the operator has not been defined" do
        expect{subject.evaluate("+", [1,2,3])}.to raise_error(ArgumentError, "No + operator is defined")
    end

    it "should raise an ArgumentError if the stack is too small" do
      subject.append Operator.new(:+, 5)
      expect{subject.evaluate("+", [1,2,3,4])}.to raise_error(ArgumentError, "The + operator requires 5 arguments.  Only 4 arguments were given")
    end

    it "should perform the operation on the last N elements of the stack and replace them with the result" do
      subject.append Operator.new(:+, 3)
      stack = [1,2,3,4,5]
      expect{subject.evaluate("+", stack)}.to change{stack}.from([1,2,3,4,5]).to([1,2,12])
    end

    it "should operate using floating point arithmetic but convert whole numbers to Fixnum when done multiplying" do
      subject.append Operator.new(:*, 3)
      stack = [1,2,3,4,5.5]
      expect{subject.evaluate("*", stack)}.to change{stack}.from([1,2,3,4,5.5]).to([1,2,66])
    end

    it "should operate using floating point arithmetic but convert whole numbers to Fixnum when done dividing" do
      subject.append Operator.new(:/, 2)
      stack = [1,2,3,7.5, 1.5]
      expect{subject.evaluate("/", stack)}.to change{stack}.from([1,2,3,7.5,1.5]).to([1,2,3,5])
    end
  end
end
