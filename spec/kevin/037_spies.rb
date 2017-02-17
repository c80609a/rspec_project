# Spies are like Test Doubles with tape recorder turned on.

RSpec.describe 'Spies' do

  # этот контекст демонстрирует возможность совместного использования
  # spy, let и before(:example). Код внутри примеров выглядит просто,
  # благодаря spy. Если бы вместо spy был double, то в каждом примере
  # появилось бы по лишней строке.
  context 'using let and before hook' do
    
    let(:ordr) do
      spy('Order', :process_line_items => nil,
                   :change_credit_card => true,
                   :send_confirmation_email => true)
    end
    
    before(:example) do
      ordr.process_line_items
      ordr.change_credit_card
      ordr.send_confirmation_email
    end

    it 'calls #process_line_items on the order' do
      expect(ordr).to have_received(:process_line_items)
    end

    it 'calls #change_credit_card on the order' do
      expect(ordr).to have_received(:change_credit_card)
    end

    it 'calls #send_confirmation_email on the order' do
      expect(ordr).to have_received(:send_confirmation_email)
    end

  end
  
end