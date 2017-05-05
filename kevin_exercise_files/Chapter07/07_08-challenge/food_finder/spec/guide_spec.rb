require 'guide'

describe Guide do

  let(:test_file) { 'spec/fixtures/restaurants_test.txt' }
  subject { Guide.new(test_file) }
  
  let(:new_file)  { 'spec/fixtures/new_restaurants_test.txt' }
  let(:new_file_path) { File.join(APP_ROOT, new_file) }
  let(:blank_guide) { Guide.new(new_file) }
  
  it 'includes NumberHelper and #number_to_currency' do
    expect(described_class.included_modules).to include(NumberHelper)
    expect(subject).to respond_to(:number_to_currency)
  end
  
  describe '#intialize' do
    
    it 'calls Restaurant#load_file with its path argument' do

      # изначально задание выглядит так:
      # skip('Needs expectation')
      # Guide.new(test_file)
      # expect ...

      ## 1) если мы напишем так (хотим сохранить порядок строк в задании):
      #   Guide.new(test_file)
      #   expect(Restaurant).to receive(:load_file).with(test_file)
      # то это без смысла, т.к. в данном случае `expect().to receive()`
      # подразумевает stubbing и делать это нужно ДО вызова `Guide.new`

      ## 2) если же мы напишем так:
      #   expect(Restaurant).to receive(:load_file).with(test_file)
      #   Guide.new(test_file)
      # т.е. поменяем местами 2 строки, то это будет похоже на
      # правильный тест, но возникает вопрос -
      # автор подразумевал ли, что так нужно сделать?
      # Ведь он даёт задание,
      # в котором строка `Guide.new` находится выше строки `# expect ..`.

      ## 3) если же мы напишем так, то мы сохраним порядок строк,
      # который был указан в исходном задании,
      # но не слишком ли много строк для такого простого теста?
      allow(Restaurant).to receive(:load_file)
      Guide.new(test_file)
      expect(Restaurant).to have_received(:load_file).with(test_file)

      # = решение
      # решение автора - это моё решение №2
      # в видео он оговаривается, что вызов `expect()` должен
      # идти перед вызовом `Guide.new()`. Также здесь не используется
      # subject.

    end
    
  end
  
  describe '#launch!' do
    
    it 'outputs a introductory message' do

      # изначально задание выглядит так:
      #   skip('Needs expectation')
      #   setup_fake_input('quit')
      #   expect ...

      # == вариант 1
      # я просто запустил приложение и выписал
      # все строки, которые оно выводит при старте
      # в переменную exp, а затем наваял тест,
      # который сравнивает это сообщение
      exp = "\n\n<<< Welcome to the Food Finder >>>\n\n"
      exp += "This is an interactive guide to help you find the food you crave.\n\n"
      exp += "Actions: list, find, add, quit\n"   # output_valid_actions
      exp += "\n<<< Goodbye and Bon Appetit! >>>\n\n\n"

      setup_fake_input('quit')
      g = Guide.new('restaurants.txt')
      m = capture_output { g.launch! }
      expect(m).to eq exp

      # == вариант 2
      # я не сравниваю полностью весь ответ, который выдаёт приложение при запуске
      # я беру лишь ключевые предложения и ищу их в introductory message.
      # одно из моих ожиданий - это regex, который подразумевает наличие
      # списка допустимых действий в introductory message.
      e1 = 'Welcome to the Food Finder'
      e2 = 'This is an interactive guide to help you find the food you crave.'
      r3 = /Actions:[ \w,]+/

      setup_fake_input('quit')
      g = Guide.new('restaurants.txt')
      m = capture_output { g.launch! }
      expect(m.include?(e1) && m.include?(e2) && r3.match(m).length > 0).to be true

      # = решение
      # Автор не использует ВЕСЬ текст, как это сделал я
      # Он берёт только одно слово - Welcome и ищет его в captured output
      # использует регулярку
      # использует `output().to_stdout`
      # использует `subject`
      # использует блок
      setup_fake_input('quit')
      expect { subject.launch! }.to output(/Welcome/).to_stdout

    end
    
  end

  describe 'performing actions' do
    
    context 'with invalid action' do
      
      it 'outputs list of valid actions' do

        # = изначально задание выглядит так
        #skip('Needs expectation')
        #setup_fake_input('invalid action', 'quit')
        # expect ...

        # = вариант 1
        # используем `subject`
        setup_fake_input('invalid action', 'quit')
        m = capture_output { subject.launch! }
        expect(m.include?('Action not recognized')).to be true

        # = решение
        # автор использует блок `expect do .. end.to`
        # использует `output().to_stdout
        # использует subject
        setup_fake_input('invalid action', 'quit')
        expect do
          subject.launch!
        end.to output(/Action not recognized./).to_stdout

      end
      
    end
    
    context 'with quit action' do
      
      it 'outputs concluding message and exits' do

        # = задание
        # skip('Needs expectation')
        # setup_fake_input('quit')
        # expect ...

        # = моё решение
        # используем subject
        # для краткости - используем регулярку
        # используем `not_to` и `be_nil`
        setup_fake_input('quit')
        m = capture_output { subject.launch! }
        expect(m[/Appetit/]).not_to be_nil

        # = решение автора
        # использует subject
        # использует блок в `expected {..}.to`
        # использует `output(..).to_stdout`
        setup_fake_input('quit')
        expect { subject.launch! }.to output(/Goodbye/).to_stdout

      end
      
    end

    context 'with list action' do
      
      it 'outputs a formatted list of restaurants' do
        setup_fake_input('list', 'quit')
        output = capture_output { subject.launch! }
        
        lines = output.split("\n")
        expect(lines[10]).to match(/^\sName\s{27}Cuisine\s{15}Price$/)
        expect(lines[11]).to eq("-" * 60)
        lines[12..17].each do |line|
          expect(line).to match(/^\s.+\s+.+\s+\$\d+\.\d{2}$/)
        end
        expect(lines[18]).to eq("-" * 60)
      end
      
      it 'outputs a message if no listings are found' do

        # = задание
        # skip("Needs expectation")
        # setup_fake_input('list', 'quit')
        # output = capture_output { blank_guide.launch! }
        # lines = output.split("\n")
        # expect(lines[10]).to match(/^\sName\s{27}Cuisine\s{15}Price$/)
        # expect(lines[11]).to eq("-" * 60)
        # expect(lines[12]).to ...
        # expect(lines[13]).to eq("-" * 60)

        # = моё решение
        # я просто написал expect(lines[12]).to match(/No listings found/)
        # регулярку использовал в стиле примера
        setup_fake_input('list', 'quit')
        output = capture_output { blank_guide.launch! }
        # puts output
        lines = output.split("\n")
        expect(lines[10]).to match(/^\sName\s{27}Cuisine\s{15}Price$/)
        expect(lines[11]).to eq("-" * 60)
        expect(lines[12]).to match(/No listings found/)
        expect(lines[13]).to eq("-" * 60)

        # = решение автора
        # полностью совпадает с моим

        # clean up
        remove_created_file(new_file_path)
      end
      
      it 'sorts alphabetically by default' do

        # = задание
        # skip('Needs expectation')
        # setup_fake_input('list', 'quit')
        # output = capture_output { subject.launch! }
        # lines = output.split("\n")
        # Use Regex to extract the names
        # names = lines[12..17].map {|l| l.match(/^\s(.+)\s+.+\s+\$\d+\.\d{2}$/)[1]}
        # Build array with the first characters
        # first_chars = names.map {|l| l[0] }
        # expect(first_chars).to ...

        # = моё решение
        # я просто сравниваю first_chars со строкой, которую я скомпоновал,
        # просматривая :test_file файл - так же надо делать?
        setup_fake_input('list', 'quit')
        output = capture_output { subject.launch! }
        lines = output.split("\n")
        # Use Regex to extract the names
        names = lines[12..17].map {|l| l.match(/^\s(.+)\s+.+\s+\$\d+\.\d{2}$/)[1]}
        # Build array with the first characters
        first_chars = names.map {|l| l[0] }
        expect(first_chars.join('')).to eq 'CHMPQT'

        # = решение автора
        # он не сравнивает со строкой,
        # он сравнивает с отсортированным массивом
        # skip('Needs expectation')
        # '<...> it should be same thing as unsorted version.'
        setup_fake_input('list', 'quit')
        output = capture_output { subject.launch! }
        lines = output.split("\n")
        # Use Regex to extract the names
        names = lines[12..17].map {|l| l.match(/^\s(.+)\s+.+\s+\$\d+\.\d{2}$/)[1]}
        # Build array with the first characters
        first_chars = names.map {|l| l[0] }
        expect(first_chars).to eq first_chars.sort

      end
      
      it 'sorts alphabetically with an invalid sort by' do
        # = задание
        #skip('Needs expectation')
        #setup_fake_input('list invalid', 'quit')
        # output = capture_output { subject.launch! }
        # lines = output.split("\n")
        # Use Regex to extract the names
        # names = lines[12..17].map {|l| l.match(/^\s(.+)\s+.+\s+\$\d+\.\d{2}$/)[1]}
        # Build array with the first characters
        # first_chars = names.map {|l| l[0] }
        # expect(first_chars).to ...

        # = моё решение
        # по-сути, ничем не отличается от предыдущего кейса
        setup_fake_input('list invalid', 'quit')
        output = capture_output { subject.launch! }
        lines = output.split("\n")
        # Use Regex to extract the names
        names = lines[12..17].map {|l| l.match(/^\s(.+)\s+.+\s+\$\d+\.\d{2}$/)[1]}
        # Build array with the first characters
        first_chars = names.map {|l| l[0] }
        expect(first_chars.join('')).to eq 'CHMPQT'

        # = решение автора
        # точно такое же, как в предыдущем примере
        # '<...> the first characters be equal of first characters if they we sorted.'
        #skip('Needs expectation')
        setup_fake_input('list invalid', 'quit')
        output = capture_output { subject.launch! }
        lines = output.split("\n")
        # Use Regex to extract the names
        names = lines[12..17].map {|l| l.match(/^\s(.+)\s+.+\s+\$\d+\.\d{2}$/)[1]}
        # Build array with the first characters
        first_chars = names.map {|l| l[0] }
        expect(first_chars).to eq first_chars.sort

      end

      it 'sorts by price when asked' do

        # = задание
        # skip('Needs expectation')
        # setup_fake_input('list price', 'quit')
        # output = capture_output { subject.launch! }
        # lines = output.split("\n")
        # prices = lines[12..17].map do |l|
          # Use Regex to extract the prices
          # string = l.match(/^\s.+\s+.+\s+\$(\d+\.\d{2})$/)[1]
          # convert '150.00' to 15000 (avoids using floats)
          # d, c = string.split('.')
          # price = (d.to_i * 100) + c.to_i
        # end
        # expect(prices).to ...

        # = моё решение
        # только я не понял смысла таких простых заданий
        setup_fake_input('list price', 'quit')
        output = capture_output { subject.launch! }
        lines = output.split("\n")
        prices = lines[12..17].map do |l|
          # Use Regex to extract the prices
          string = l.match(/^\s.+\s+.+\s+\$(\d+\.\d{2})$/)[1]
          # convert '150.00' to 15000 (avoids using floats)
          d, c = string.split('.')
          price = (d.to_i * 100) + c.to_i
        end
        # puts prices
        expect(prices).to eq [500,1000,1000,2500,3000,3500]

        # = решение автора
        # такое же, как и в предыдущих примерах
        # сравнивает получившийся массив с отсортированным массивом
        # skip('Needs expectation')
        setup_fake_input('list price', 'quit')
        output = capture_output { subject.launch! }
        lines = output.split("\n")
        prices = lines[12..17].map do |l|
          # Use Regex to extract the prices
          string = l.match(/^\s.+\s+.+\s+\$(\d+\.\d{2})$/)[1]
          # convert '150.00' to 15000 (avoids using floats)
          d, c = string.split('.')
          price = (d.to_i * 100) + c.to_i
        end
        expect(prices).to eq prices.sort

      end

      it 'sorts by cuisine when asked' do

        # = задание
        # skip('Needs expectation')
        # setup_fake_input('list cuisine', 'quit')
        # output = capture_output { subject.launch! }
        # lines = output.split("\n")
        # Use Regex to extract the cuisines
        # cuisines = lines[12..17].map do |l|
        #   l.match(/^\s.+\s+(.+)\s+\$\d+\.\d{2}$/)[1]
        # end
        # expect(cuisines).to ...

        # = моё решение
        # а здесь попался regex от автора
        # который не сработал, надо было
        # переделать. (другой вопрос - почему не сработал авторский regex?)
        # Итак, необходимо из строк вида:
        #
        #   Quick Cup                      Coffee                $5.00
        #   Pita Pocket                    Fast Food            $10.00
        #   Taste Of Little Italy          Pizza                $10.00
        #   Mallard House                  New American         $35.00
        #
        # извлечь столбец с кухнями.
        # изучаем `Guide.output_restaurant_table`:
        #   * первые 31 символа строки - это название ресторана
        #   * после идут 21 символ с названием кухни
        # + пригодился 'String#strip'
        setup_fake_input('list cuisine', 'quit')
        output = capture_output { subject.launch! }
        lines = output.split("\n")
        # Use Regex to extract the cuisines
        cuisines = lines[12..17].map do |l|
          # puts l.match(/(?<=^\s[\w\s]{30})(\s[\w\s]{20})/)[1]
          # l.match(/^\s.+\s+(.+)\s+\$\d+\.\d{2}$/)[1]
          l.match(/(?<=^\s[\w\s]{30})(\s[\w\s]{20})/)[1].strip
        end
        expect(cuisines).to eq %w'Coffee Fast\ Food Indian Mexican New\ American Pizza'
        # puts cuisines

        # = решение автора
        # такое же, как и в предыдущих примерах
        # сравнивает массив со своей отсортированной версией
        setup_fake_input('list cuisine', 'quit')
        output = capture_output { subject.launch! }
        lines = output.split("\n")
        # Use Regex to extract the cuisines
        cuisines = lines[12..17].map do |l|
          # puts l.match(/(?<=^\s[\w\s]{30})(\s[\w\s]{20})/)[1]
          # l.match(/^\s.+\s+(.+)\s+\$\d+\.\d{2}$/)[1]
          l.match(/(?<=^\s[\w\s]{30})(\s[\w\s]{20})/)[1].strip
        end
        expect(cuisines).to eq cuisines.sort

      end
      
    end

    context 'with find action' do
      
      it 'outputs instructions if no arguments given' do

        # = задание
        # skip('Needs expectation')
        # setup_fake_input('find', 'quit')
        # output = capture_output { subject.launch! }
        # expect(output).to ...

        # = моё решение
        setup_fake_input('find', 'quit')
        output = capture_output { subject.launch! }
        # puts output
        expect(output).to match(/Examples/)
        # expect(output).to ...

        # = решение автора
        # использует matcher `include`, и подаёт туда key phrase
        setup_fake_input('find', 'quit')
        output = capture_output { subject.launch! }
        expect(output).to include('Find using a key phrase to search the restaurant list')

      end
      
      it 'finds restaurants with matching name keyword' do

        # = задание
        # skip('Needs expectation')
        # setup_fake_input('find cafe', 'quit')
        # output = capture_output { subject.launch! }
        #
        # lines = output.split("\n")
        # expect(lines[11]).to eq("-" * 60)
        # expect(lines[12]).to ...
        # expect(lines[13]).to eq("-" * 60)

        # = моё решение
        setup_fake_input('find cafe', 'quit')
        output = capture_output { subject.launch! }

        lines = output.split("\n")
        expect(lines[11]).to eq('-' * 60)
        expect(lines[12]).to match(/Indian/)
        expect(lines[13]).to eq('-' * 60)
        # puts lines[12]

        # = решение автора
        # аналогично решению в предыдущем примере
        # использует matcher `include`
        setup_fake_input('find cafe', 'quit')
        output = capture_output { subject.launch! }

        lines = output.split("\n")
        expect(lines[11]).to eq('-' * 60)
        expect(lines[12]).to include('Masala')
        expect(lines[13]).to eq('-' * 60)

      end

      it 'finds restaurants with matching cuisine keyword' do

        # = задание
        # skip('Needs expectation')
        # setup_fake_input('find mexican', 'quit')
        # output = capture_output { subject.launch! }
        #
        # lines = output.split("\n")
        # expect(lines[11]).to eq("-" * 60)
        # expect(lines[12]).to ...
        # expect(lines[13]).to eq("-" * 60)

        # = моё решение
        # почему так просто?
        setup_fake_input('find mexican', 'quit')
        output = capture_output { subject.launch! }

        lines = output.split("\n")
        expect(lines[11]).to eq('-' * 60)
        expect(lines[12]).to match(/Mexican/)
        expect(lines[13]).to eq('-' * 60)

        # = решение автора
        # аналогично предыдущему кейсу
        setup_fake_input('find mexican', 'quit')
        output = capture_output { subject.launch! }

        lines = output.split("\n")
        expect(lines[11]).to eq('-' * 60)
        expect(lines[12]).to include 'Mexican'
        expect(lines[13]).to eq('-' * 60)

      end
      
      it 'finds restaurants with prices less than keyword' do

        # = Задание
        # skip('Needs expectation')
        # setup_fake_input('find 10', 'quit')
        # output = capture_output { subject.launch! }
        #
        # lines = output.split("\n")
        # expect(lines[11]).to eq("-" * 60)
        # expect(lines[12]).to ...
        # expect(lines[13]).to ...
        # expect(lines[14]).to ...
        # expect(lines[15]).to eq("-" * 60)

        # = Решение
        setup_fake_input('find 10', 'quit')
        output = capture_output { subject.launch! }

        lines = output.split("\n")
        expect(lines[11]).to eq('-' * 60)
        expect(lines[12]).to match(/Fast Food/)
        expect(lines[13]).to match(/Coffee/)
        expect(lines[14]).to match(/Pizza/)
        expect(lines[15]).to eq('-' * 60)

        # = Решение автора
        # аналогично предыдущим кейсам
        # использует matcher `include`
        setup_fake_input('find 10', 'quit')
        output = capture_output { subject.launch! }

        lines = output.split("\n")
        expect(lines[11]).to eq('-' * 60)
        expect(lines[12]).to include 'Fast Food'
        expect(lines[13]).to include 'Coffee'
        expect(lines[14]).to include 'Pizza'
        expect(lines[15]).to eq('-' * 60)

      end

    end

    context 'with add action' do

      let(:fake_file) do
        double('Fake Restaurant Instance', :save => true)
      end
      
      before(:example) do
        # keeps it from creating a new file
        allow(Restaurant).to receive(:new).with(any_args).
          and_return(fake_file)
        setup_fake_input('add', 'Chelsea Diner', 'American', '20', 'quit')
      end
      
      it 'asks questions about restaurant to add' do
        # Questions:
        # "Restaurant name: "   :name
        # "Cuisine type: "      :cuisine
        # "Average price: "     :price

        # = задание
        # output = capture_output { subject.launch! }
        # expect(output).to match(...)
        # expect(output).to match(...)
        # expect(output).to match(...)

        # = решение
        # не решение, а тренировка десятипальцевого метода
        # английских слов
        output = capture_output { subject.launch! }
        expect(output).to match(/Restaurant name/)
        expect(output).to match(/Cuisine type/)
        expect(output).to match(/Average price/)
        # puts output

        # = решение автора
        # совпадает с моим
      end

      it 'sends question answers to Restaurant.new' do

        # = задание
        # skip("Needs expectation")
        # subject.launch!
        # expect(Restaurant).to ...

        # = решение
        # это из темы 'message arguments expectations'
        expected_args = {
            :name => 'Chelsea Diner',
            :cuisine => 'American',
            :price => '20'
        }
        expect(Restaurant).to receive(:new).with(expected_args)
        subject.launch!

        # = решение автора
        # аналогично моему

      end

    end
    
  end

end
