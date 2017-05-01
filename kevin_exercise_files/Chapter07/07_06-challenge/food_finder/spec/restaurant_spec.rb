require_relative '../lib/restaurant'

describe Restaurant do

  let(:test_file) { 'spec/fixtures/restaurants_test.txt' }
  let(:crescent) { Restaurant.new(:name => 'Crescent', :cuisine => 'paleo', :price => '321') }
  
  describe 'attributes' do

    # мои решения в этом блоке построены по следующему принципу:
    # раз уж требуется в одном тесте проверить и reading и writing,
    # то сначала мы читаем оригинальное значение (сохраняя его в переменную `read_*`),
    # а затем пишем новое значение (сохраняя его в переменную `write_*`).
    # После - лабаем массив из этих двух переменных и проверяем его

    it 'allow reading and writing for :name' do
      read_name = crescent.name
      crescent.name = 'Caesar'
      write_name = crescent.name
      expect([read_name, write_name]).to eq %w(Crescent Caesar)
    end

    it 'allow reading and writing for :cuisine' do
      read_cuisine = crescent.cuisine
      crescent.cuisine = 'mexican'
      write_cuisine = crescent.cuisine
      expect([read_cuisine, write_cuisine]).to eq %w(paleo mexican)
    end

    it 'allow reading and writing for :price' do
      read_price = crescent.price
      crescent.price = '123'
      write_price = crescent.price
      expect([read_price, write_price]).to eq %w(321 123)
    end
    
  end
  
  describe '.load_file' do

    # сказано - пропустить, уже сделано

    it 'does not set @@file if filepath is nil' do
      no_output { Restaurant.load_file(nil) }
      expect(Restaurant.file).to be_nil
    end
    
    it 'sets @@file if filepath is usable' do
      no_output { Restaurant.load_file(test_file) }
      expect(Restaurant.file).not_to be_nil
      expect(Restaurant.file.class).to be(RestaurantFile)
      # noinspection RubyResolve
      expect(Restaurant.file).to be_usable
    end

    it 'outputs a message if filepath is not usable' do
      expect do
        Restaurant.load_file(nil)
      end.to output(/not usable/).to_stdout
    end
    
    it 'does not output a message if filepath is usable' do
      expect do
        Restaurant.load_file(test_file)
      end.not_to output.to_stdout
    end


  end
  
  describe '.all' do

    it 'returns array of restaurant objects from @@file' do

      # В этом примере необходимо проверить,
      # что метод класса просто возвращает массив из 6 объектов
      # типа Restaurant.
      # Пример тривиальный, решение лёгкое, можно было бы
      # ограничится одной строкой для затравки.

      Restaurant.load_file(test_file)
      restaurants = Restaurant.all
      expect(restaurants.class).to eq(Array)
      expect(restaurants.length).to eq(6)
      expect(restaurants.first.class).to eq(Restaurant)
    end

    it 'returns an empty array when @@file is nil' do
      no_output { Restaurant.load_file(nil) }
      restaurants = Restaurant.all
      expect(restaurants).to eq([])
    end
    
  end
  
  describe '#initialize' do

    context 'with no options' do
      # subject would return the same thing
      let(:no_options) { Restaurant.new }

      it 'sets a default of "" for :name' do
        no_options.name = ''
      end

      it 'sets a default of "unknown" for :cuisine' do
        no_options.cuisine = 'unknown'
      end

      it 'does not set a default for :price' do
        no_options.price = nil
      end
    end
    
    context 'with custom options' do

      subject(:with_options) { Restaurant.new({:name => '1', :cuisine => '2', :price => '3'}) }

      it 'allows setting the :name' do
        expect(with_options.name).to eq '1'
      end

      it 'allows setting the :cuisine' do
        expect(with_options.cuisine).to eq '2'
      end

      it 'allows setting the :price' do
        expect(with_options.price).to eq '3'

      end

    end

  end
  
  describe '#save' do
    
    it 'returns false if @@file is nil' do
      expect(crescent.save).to eq false
    end
    
    it 'returns false if not valid' do
      crescent.price = -1
      expect(crescent.save).to eq false
    end
    
    it 'calls append on @@file if valid' do

      # Здесь используется 'Partial Test Double',
      # чтобы не записывать изменения в файл,
      # не портить его, так скажем

      Restaurant.load_file(test_file)
      allow(Restaurant.file).to receive(:append).and_return(true)
      expect(crescent.save).to eq true
    end
    
  end
  
  describe '#valid?' do

    # я решил опять применить Partial Test Double
    # так же можно?

    it 'returns false if name is nil' do
      allow(crescent).to receive(:name).and_return(nil)
      expect(crescent.valid?).to eq false
    end

    it 'returns false if name is blank' do
      allow(crescent).to receive(:name).and_return('')
      expect(crescent.valid?).to eq false
    end

    it 'returns false if cuisine is nil' do
      allow(crescent).to receive(:cuisine).and_return(nil)
      expect(crescent.valid?).to eq false
    end

    it 'returns false if cuisine is blank' do
      allow(crescent).to receive(:cuisine).and_return('')
      expect(crescent.valid?).to eq false
    end
    
    it 'returns false if price is nil' do
      allow(crescent).to receive(:price).and_return(nil)
      expect(crescent.valid?).to eq false
    end

    it 'returns false if price is 0' do
      allow(crescent).to receive(:price).and_return(0)
      expect(crescent.valid?).to eq false
    end
    
    it 'returns false if price is negative' do
      allow(crescent).to receive(:price).and_return(-1)
      expect(crescent.valid?).to eq false
    end

    it 'returns true if name, cuisine, price are present' do
      expect(crescent.valid?).to eq true
    end
    
  end

end
