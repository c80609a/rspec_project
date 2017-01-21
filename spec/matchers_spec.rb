# include 'matchers'

RSpec.describe 'Matchers' do

=begin
  it 'asserts on equality' do
    number = 3
    # number.should == 3
    expect(number).to eq 3
  end

  it 'asserts on mathematical operators' do
    number = 5
    expect(number).to be >= 2
  end

  it 'asserts on thruthiness' do
    bool = true
    falsy_bool = false
    nil_value = nil
    object = Class.new
    
    expect(object).to be_falsey

  end
=end

  specify 'expects errors' do
    expect do
      raise ArgumentError
    end.to raise_error TypeError
  end

end
