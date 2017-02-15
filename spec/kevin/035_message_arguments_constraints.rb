RSpec.describe 'Message Arguments Constraints' do

  # В этом тривиальном примере просто отображается возможность декларировать
  # ожидания от ЗНАЧЕНИЯ аргумента, который подаётся в метод.
  # При этом у test double метод вызывается напрямую и аргумент подаётся ожидаемый.
  # Само собой, тест проходит.
  #
  # Если же заменить значение аргумента на иное,
  # неожиданное, то тест упадёт с сообщением "received :sort with unexpected arguments"
  it 'allows constraints on arguments (specific value)' do
    dbl = double('Customer List')
    expect(dbl).to receive(:sort).with('name')
    dbl.sort('name')
  end

  # В этом тривиальном примере демонстрируется ожидание
  # ЛЮБЫХ аргументов метода. Метод вызывается явно.
  # Это default state - т.е. если не указывать `.with(..)` - будут подразумеваться любые агругменты.
  it 'allows constrains on arguments (any_args)' do
    dbl = double('Customers list')
    expect(dbl).to receive(:sort).with(any_args)
    dbl.sort('name')
  end

  # Здесь в метод ожидается приход трёх аргументов разных типов
  it 'works the same with multiple arguments' do
    dbl = double('Customer List')
    expect(dbl).to receive(:sort).with('name', :asc, true)
    dbl.sort('name', :asc, true)
  end

  # В данном примере показаны ожидания только касательно некоторых аргументов.
  # Используется ключевое слово `anything`
  it 'allows constraining only some arguments' do
    dbl = double('Customer List')
    expect(dbl).to receive(:sort).with('name', anything, anything)
    dbl.sort('name', :desc, false)
  end

  # В этом примере показаны ожидания от аргументов,
  # значения которых должны соответствовать matcher-ам
  it 'allows using other matchers' do
    dbl = double('Customer List')
    expect(dbl).to receive(:sort).with(a_string_starting_with('n'),
                                       an_object_eq_to(:asc) | an_object_eq_to(:desc),
                                       boolean
                   )
    dbl.sort('name', :asc, false)
  end

end