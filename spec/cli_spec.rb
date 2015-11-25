require "cli"

describe CLI do
  it "should not allow tokens that contain alphas" do
    expect($stdout).to receive(:puts).with("'A' is not a valid input")
    expect(subject.handle_token {"A" }).to eq(true)
  end

  it "should not allow tokens that contain digits followed by alphas" do
    expect($stdout).to receive(:puts).with("'22A' is not a valid input")
    expect(subject.handle_token {"22A" }).to eq(true)
  end

  it "should allow and trim leading and trailing whitespace" do
    expect($stdout).to receive(:puts).with(22)
    expect(subject.handle_token { "   22   " }).to eq(true)
    expect(subject.stack).to contain_exactly(22)
  end

  it "should convert whole numbers to Fixnum" do
    expect($stdout).to receive(:puts).with(22)
    expect(subject.handle_token { "22.0" }).to eq(true)
    expect(subject.stack).to contain_exactly(22)
  end

  it "should preserve precision when not a whole number" do
    expect($stdout).to receive(:puts).with(22.4)
    expect(subject.handle_token { "22.4" }).to eq(true)
    expect(subject.stack).to contain_exactly(22.4)
  end

  describe "when fed a + operator" do
    it "should operate on the stack and print the result" do
      subject.stack << 3 << 9
      expect($stdout).to receive(:puts).with(12)
      expect{expect(subject.handle_token { "+" }).to eq(true)}.to change{subject.stack}.from([3,9]).to([12])
    end

    describe "when there are not enough elements on the stack" do
      it "should state the error and not alter the stack" do
        subject.stack << 3
        expect($stdout).to receive(:puts).with("The + operator requires 2 arguments.  Only 1 arguments were given")
        expect{expect(subject.handle_token { "+" }).to eq(true)}.not_to change{subject.stack}.from([3])
      end
    end
  end

  describe "when fed a 'q'" do
    it "should return false" do
      subject.stack << 3
      expect($stdout).not_to receive(:puts)
      expect(subject.handle_token { "q" }).to eq(false)
    end
  end

  describe "when an Interrupt is raised" do
    it "should return false" do
      expect($stdout).not_to receive(:puts)
      expect(subject.handle_token { raise Interrupt }).to eq(false)
    end
  end

  describe "when a StandardError is raised" do
    it "should return false and print the backtrace" do
      expect($stdout).to receive(:puts).once.with("Something wierd happened")
      expect($stdout).to receive(:puts).once do |arg|
        expect(arg[0]).to match(/spec\/cli_spec\.rb:#{__LINE__ + 2}:in \`block \(4 levels\) in <top \(required\)>'/)
      end
      expect(subject.handle_token { raise StandardError, "Something wierd happened" }).to eq(true)
    end
  end
end
