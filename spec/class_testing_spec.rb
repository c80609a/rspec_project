RSpec.describe 'Class testing' do

  it 'У магазина (данные которого идут на экспорт) должны быть площади.' do

    class Shop

      attr_reader :areas

      def initialize
        @areas = []
      end

      def add_area(area)
        @areas << area
      end

      def assign?
        self.areas.count > 0
      end

    end

    shop = Shop.new
    # shop.add_area(:area)

    expect(shop).to be_assign

  end


end