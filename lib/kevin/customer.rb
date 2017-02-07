module Kevin
  class Customer

    def initialize(name='noname')
      @name = "My name is #{name}"
    end

    # вернуть одного Customer (как бы запрос к базе данных)
    def self.find
      self.new
    end

    # вернуть всех известных Customers (как бы запрос к базе)
    def self.all
      c1 = self.new
      c2 = self.new
      c3 = self.new
      [c1, c2, c3]
    end

  end
end