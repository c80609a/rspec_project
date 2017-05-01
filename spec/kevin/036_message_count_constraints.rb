require_relative '../../lib/kevin/car'

RSpec.describe 'Message count constraints' do

  subject(:car) { Kevin::Car.new }

  # В этом примере :
  #  - во-первых, используется subject
  #  - во-вторых, проверяется, что при обращении к одному методу, другой метод вызовется дважды
  it '#restock_item should be called twice' do
    expect(car).to receive(:restock_item).twice

    car.add_item(12)
    car.add_item(344)
    car.empty
  end

end