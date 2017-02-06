# терморядерный пример из relishapp с глобальной переменной и именованными субъектами (named subject)

$count = 0

RSpec.describe 'Named subject' do

  subject(:global_count) {
    puts "[CALL] $count = #{$count}"
    $count += 1
  }

  it 'memoized across calls (i.e. the block is invoked once)' do
    expect {
      2.times {
        global_count
      }
    }.not_to change {
               global_count
             }.from(1)
  end

  it 'is not cached across examples' do
    expect(global_count).to eq(2)
  end

end