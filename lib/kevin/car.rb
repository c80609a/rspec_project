module Kevin
  class Car

    def initialize
      p self # NOTE:: а тут я проверял, что в случае `implicitly defined subject` предмет тестирования пересоздаётся перед каждым примером
      @wheels = [1,2,3,4]
    end

    def wheels_count
      @wheels.count
    end

    def tanked?
      true
    end

  end
end