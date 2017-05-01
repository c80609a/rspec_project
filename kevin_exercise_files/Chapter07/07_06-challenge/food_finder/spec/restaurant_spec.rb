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
    #
    # Решение от Кевина выглядит лаконичнее:
    #   - он использует (незамеченное мною) "implicitly defined subject"
    #   - во-вторых, можно было просто один раз записать, один раз прочитать

    it 'allow reading and writing for :name' do

      # моё решение:
      # read_name = crescent.name
      # crescent.name = 'Caesar'
      # write_name = crescent.name
      # expect([read_name, write_name]).to eq %w(Crescent Caesar)

      subject.name = 'Caesar'
      expect(subject.name).to eq 'Caesar'

    end

    it 'allow reading and writing for :cuisine' do

      # моё решение:
      # read_cuisine = crescent.cuisine
      # crescent.cuisine = 'mexican'
      # write_cuisine = crescent.cuisine
      # expect([read_cuisine, write_cuisine]).to eq %w(paleo mexican)

      subject.cuisine = 'mexican'
      expect(subject.cuisine).to eq 'mexican'

    end

    it 'allow reading and writing for :price' do

      # read_price = crescent.price
      # crescent.price = '123'
      # write_price = crescent.price
      # expect([read_price, write_price]).to eq %w(321 123)

      subject.price = 123
      expect(subject.price).to eq 123

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

      # исправляю своё "решение" - я когда писал его,
      # думал явно о чём-то другом

      it 'sets a default of "" for :name' do
        expect(no_options.name).to eq ''
      end

      it 'sets a default of "unknown" for :cuisine' do
        expect(no_options.cuisine).to eq 'unknown'
      end

      it 'does not set a default for :price' do
        # моё решение:
        # expect(no_options.price).to eq nil

        # решение автора - он использует `be_nil`
        expect(no_options.price).to be_nil
      end
    end
    
    context 'with custom options' do

      # здесь я завёл `subject`, хотя можно было
      # использовать более глобальный `let(:crescent)`

      # моё решение
      # subject(:with_options) { Restaurant.new({:name => '1', :cuisine => '2', :price => '3'}) }

      it 'allows setting the :name' do
        # моё решение
        # expect(with_options.name).to eq '1'

        expect(crescent.name).to eq 'Crescent'
      end

      it 'allows setting the :cuisine' do
        # моё решение
        # expect(with_options.cuisine).to eq '2'

        expect(crescent.cuisine).to eq 'paleo'
      end

      it 'allows setting the :price' do
        # моё решение
        # expect(with_options.price).to eq '3'

        expect(crescent.price).to eq '321'
      end

    end

  end
  
  describe '#save' do
    
    it 'returns false if @@file is nil' do
      # моё решение:
      # expect(crescent.save).to eq false

      # решение автора состоит из двух ожиданий:
      expect(Restaurant.file).to be_nil
      expect(crescent.save).to be false

    end
    
    it 'returns false if not valid' do
      # моё решение: я забыл загрузить файл,
      # перед тем, как делать crescent невалидным
      # этот тест пройдёт, даже если закомментировать
      # первую строчку
      # crescent.price = -1
      # expect(crescent.save).to eq false

      # решение автора: сначала надо загрузить
      # файл, затем попытаться сохранить в него
      # конкретный ресторан - subject
      Restaurant.load_file(test_file)
      expect(Restaurant.file).to_not be_nil
      expect(subject.save).to be false


    end
    
    it 'calls append on @@file if valid' do

      # Здесь используется 'Partial Test Double',
      # чтобы не записывать изменения в файл,
      # не портить его, так скажем

      # моё решение:
      #   оно ошибочно, т.к. если я закомментирую последнюю
      #   строку, то тест всё-равно пройдёт
      # Restaurant.load_file(test_file)
      # allow(Restaurant.file).to receive(:append).and_return(true)
      # expect(crescent.save).to eq true

      # решение автора:
      # 0) в самом начале после загрузки файла автор проверил
      #   что файл загрузился.
      # 1) в первую очередь он проверил,
      #   что метод `append` вызовется с аргументом,
      # 2) и он не использует `allow`, а юзает более строий `expect`.
      # 3) И в файл не происходит записи.
      Restaurant.load_file(test_file)
      expect(Restaurant.file).to_not be_nil
      expect(Restaurant.file).to receive(:append).with(crescent)
      crescent.save

    end
    
  end
  
  describe '#valid?' do

    # я решил опять применить Partial Test Double
    # так же можно?

    it 'returns false if name is nil' do

      # моё решение:
      # allow(crescent).to receive(:name).and_return(nil)

      # решение автора ( и так далее во всех оставшихся тестах этой группы):
      crescent.name = nil

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
