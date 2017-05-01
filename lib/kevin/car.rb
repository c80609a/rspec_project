module Kevin
  class Car

    def initialize
      p self # NOTE:: а тут я проверял, что в случае `implicitly defined subject` предмет тестирования пересоздаётся перед каждым примером
      @wheels = [1,2,3,4]
      @items = []
    end

    def wheels_count
      @wheels.count
    end

    def tanked?
      true
    end

    def add_item(id)
      @items << id
    end

    def restock_item(id)
      @items.delete(id)
    end

    def empty
      @items.each { |id| restock_item(id) }
    end

  end
end