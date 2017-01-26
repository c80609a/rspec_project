require 'blog'
require 'post'

RSpec.describe Blog do

  it 'has no posts' do
    blog = Blog.new
    expect(blog).to be_empty
  end

  it 'has a post when initialized with one' do
    blog = Blog.new([Post.new])
    expect(blog.posts_count).to eq 1
  end


end