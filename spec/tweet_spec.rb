require_relative '../lib/tweet'

RSpec.describe 'Tweet' do
  it 'without a leading @ should be public' do
    tweet = Tweet.new(status: 'hom hom hom')
    # expect(tweet).to be_public
    # или
    expect(tweet).to be_public
  end
end