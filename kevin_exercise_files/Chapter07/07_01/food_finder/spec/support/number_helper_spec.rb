# encoding: UTF-8

describe 'NumberHelper' do

  include NumberHelper

  describe '#number_to_currency' do

    context 'using default values' do

      it "correctly formats an integer" do
        n = 10
        expect(number_to_currency(n)).to eq '$10.00'
      end

      it "correctly formats a float" do
        n = 10.5
        expect(number_to_currency(n)).to eq '$10.50'
      end

      it "correctly formats a string" do
        n = '100'
        expect(number_to_currency(n)).to eq '$100.00'
      end

      it "uses delimiters for very large numbers" do
        n = 100099
        # expect(number_to_currency(n)).to eq '$100,099.00'
        c = number_to_currency(n).index(',')
        # expect(c).not_to eq nil
        expect(c).to be_truthy
      end

      it "does not have delimiters for small numbers" do
        n = 100
        c = number_to_currency(n).index(',')
        expect(c).to eq nil
      end

    end

    context 'using custom options' do

      it 'allows changing the :unit' do
        n = 10500
        u = 'RUR '
        expect(number_to_currency(n, {:unit => u})).to eq 'RUR 10,500.00'
      end

      it 'allows changing the :precision' do
        n = 10
        p = 3
        expect(number_to_currency(n, {:precision => p})).to eq '$10.000'
      end

      it 'omits the separator if :precision is 0' do
        n = 10
        p = 0
        # expect(number_to_currency(n, {:precision => p})).to eq '$10'
        c = number_to_currency(n, {:precision => p}).index('.')
        expect(c).to eq nil
      end

      it 'allows changing the :delimiter' do
        n = 100500
        d = ' '
        expect(number_to_currency(n, {:delimiter => d})).to eq '$100 500.00'
      end

      it 'allows changing the :separator' do
        n = 10500
        s = '-'
        expect(number_to_currency(n, {:separator => s})).to eq '$10,500-00'
      end

      it 'correctly formats using multiple options' do
        n = 100500
        s = '-'
        d = ' '
        p = 3
        u = 'RUR '
        expect(number_to_currency(n, {
                                       :unit      => u,
                                       :precision => p,
                                       :delimiter => d,
                                       :separator => s
                                   })).to eq 'RUR 100 500-000'
      end

    end

  end

end
