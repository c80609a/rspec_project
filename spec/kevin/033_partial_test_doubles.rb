require 'kevin/super_hero'
require 'kevin/customer'

RSpec.describe 'Partial test doubles' do

  # Демонстрация возможности частичной заглушки экземпляра класса Time
  it 'stubs instance method of Time object' do

    t = Time.new(2017, 2, 7, 7, 14, 0)
    allow(t).to receive(:year).and_return(1975)

    expect(t.to_s).to eq '2017-02-07 07:14:00 +0300'
    expect(t.year).to eq 1975

  end

  # Частично заглушаем методы экземляра собственного класса
  it 'stubs instance method of SuperHero object' do

    hero = Kevin::SuperHero.new
    expect(hero.name).to eq 'Superman'

    allow(hero).to \
      receive(:name).and_return('Klark')

    expect(hero.name).to eq 'Klark'

  end

  # В данном примере заглушаем метод now класса Time - подделываем возвращаемое значение
  it 'stubs class methods on real objects' do

    fixed = Time.new(2017, 2, 7, 7, 58)
    allow(Time).to receive(:now).and_return(fixed)

    expect(Time.now).to eq fixed
    expect(Time.now.year).to eq 2017

  end

  # Здесь подделываем ответ от метода, который обращается к базе данных и возвращаем 1 mock-объект
  it 'can stub database calls: Customer.find' do

    # true mock object: полная подделка (имитирует класс Kevin::Customer)
    dbl = double('Mock Customer')
    allow(dbl).to receive(:name).and_return('Mary Jane')

    # подделываем ответ от метода класса find (который обращается к базе данных)
    allow(Kevin::Customer).to receive(:find).and_return(dbl)

    customer = Kevin::Customer.find
    expect(customer.name).to eq 'Mary Jane'


  end

  # тоже самое, что и пример выше, только ожидаем 2 mock-объекта и подделываем ответ от метода класса all
  it 'can stub database calls: Customer.all' do

    dbl_1 = double('Mock customer A')
    dbl_2 = double('Mock customer B')

    allow(Kevin::Customer).to receive(:all).and_return([dbl_1, dbl_2])

    customers = Kevin::Customer.all
    expect(customers[0]).to eq dbl_1
    expect(customers[1]).to eq dbl_2

  end

end