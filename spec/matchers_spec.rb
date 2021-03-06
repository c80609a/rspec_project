# include 'matchers'

RSpec.describe 'Matchers' do

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
    bool       = true
    falsy_bool = false
    nil_value  = nil
    object     = Class.new

    expect(object).to be_falsey

  end

  specify 'expects errors' do
    expect do
      raise ArgumentError
    end.to raise_error TypeError
  end

  specify 'except throws' do
    expect do
      throw :oops
    end.to throw_symbol :oops
  end

  it 'asserts on predicates' do

    class Shop
      def assign?
        true
      end
    end

    expect(Shop.new).to be_assign

  end

  it 'assets on collections' do
    list = [
        :one,
        :two,
        :three
    ]

    expect(list).to include :one
    expect(list).to start_with :one

  end

end
