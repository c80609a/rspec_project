# https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers/be-matchers

RSpec.describe 'be_truthy matcher' do

  # specify { expect(false).to be_truthy }
  # specify { expect(nil).to be_truthy }
  specify { expect(7).to be_truthy }
  specify { expect(Class.new).to be_truthy }
  specify { expect('foo').to be_truthy }
  specify { expect(true).to be_truthy }

  specify { expect(false).not_to be_truthy }
  # specify { expect(true).not_to be_truthy }
  # specify { expect(7).not_to be_truthy }
  # specify { expect('str').not_to be_truthy }
  specify { expect(nil).not_to be_truthy }

end