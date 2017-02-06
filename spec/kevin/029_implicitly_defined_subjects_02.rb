# В этом файле предмет тестирования задаётся *неявно*.

require 'kevin/car'

RSpec.describe Kevin::Car do

  it 'имеется бензин в баке' do # NOTE:: заодно вспоминаем т.н. asserts on predicates
    expect(subject).to be_tanked # NOTE:: была ошибка - знак вопроса ставить тут в конец не неужно
  end

  it 'имеет 4 колеса' do
    expect(subject.wheels_count).to eq 4
  end

end