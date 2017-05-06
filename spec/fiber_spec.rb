require 'fiber'

RSpec.describe 'Fiber:' do

  it 'Проверяем возможность передачи аргумента в блок' do
    f = Fiber.new do |i|
      i + 1
    end
    expect(f.resume 6).to eq 7
  end

  context 'Проверяем много волокон:' do # и замеряем время

    let(:max) { 10000 }

    it 'способ 1' do #  0.124
      act = max.times { Fiber.new{} }
      expect(max).to eq act
    end

    it 'способ 2' do # 0.04 быстрее способа 1
      act = (0..max).each { Fiber.new{} }
      expect(0..max).to eq act
    end

    it 'способ 3' do # 0.07
      act2 = max.times { Fiber.new{}.resume }
      expect(max).to eq act2
    end

  end

  describe 'Ошибки и исключения:' do

    it 'Если при создании волокна не предоставляется блок - кидается ArgumentError' do
      expect { Fiber.new }.to raise_error ArgumentError
    end

    context 'Выкидывается FiberError:' do

      it 'если пытаемся использовать мёртвое волокно' do
        expect do
          f = Fiber.new{}
          f.resume
          f.resume
        end.to raise_error FiberError
      end

      it 'если хотим вызвать yield находясь в root' do
        expect { Fiber.yield }.to raise_error FiberError
      end

      it 'в случае double resume' do

        expect do
          f = Fiber.new do
            f.resume
          end
          f.resume
        end.to raise_error FiberError

        expect do
          f1 = Fiber.new do
            Fiber.new do
              f1.resume
            end.resume
          end
          f1.resume
        end.to raise_error FiberError

      end

      it 'если хотим resume волокно, из которого передали управление' do
        expect do
          f = Fiber.new { f.resume }
          f.transfer
        end.to raise_error FiberError
      end

    end

  end

end