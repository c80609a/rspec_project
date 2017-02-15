RSpec.describe 'Message Expectations' do

  it 'expects a call and allows a response' do

    dbl = double('Chant')

    expect(dbl).to receive(:hey!).and_return('Ho')

    dbl.hey!

  end

  it 'does not matter which order' do

    dbl = double('Chant')

    expect(dbl).to receive(:hey_1)
    expect(dbl).to receive(:hey_2)

    dbl.hey_2
    dbl.hey_1

  end

  it 'works with #ordered when order matters' do

    dbl = double('Chant')

    expect(dbl).to receive(:hey_1).ordered
    expect(dbl).to receive(:hey_2).ordered

    dbl.hey_1
    dbl.hey_2

  end

end