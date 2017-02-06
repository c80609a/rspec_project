# В данном листинге предмет тестирования задан *явно*.

require 'kevin/car' # NOTE:: тут была загвоздка - не знал, как правильно обратиться к классу, находящемся в поддиректории

RSpec.describe 'Kevin::Car' do

  subject { Kevin::Car.new }

  it 'имеет 4 колеса' do
    expect(subject.wheels_count).to eq 4
  end

end
