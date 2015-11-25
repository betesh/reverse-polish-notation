require "operator"

describe Operator do
  subject { described_class.new(:**, 2) }

  it "should raise an ArgumentError if too many arguments" do
    expect{subject.evaluate(2,8,8)}.to raise_error(ArgumentError, "The ** operator takes exactly 2 arguments, not 3")
  end

  it "should raise an ArgumentError if too few arguments" do
    expect{subject.evaluate(2)}.to raise_error(ArgumentError, "The ** operator takes exactly 2 arguments, not 1")
  end

  it "should operator using the operator" do
    expect(subject.evaluate(2,8)).to eq(256)
  end

  it "cannot take a String as the first initializer argument" do
    expect{described_class.new("**", 8)}.to raise_error(ArgumentError, "The first argument to Operator.new must be a Symbol")
  end

  it "cannot take a Float as the second initializer argument" do
    expect{described_class.new(:**, 4.4)}.to raise_error(ArgumentError, "The second argument to Operator.new must be a Fixnum")
  end
end
