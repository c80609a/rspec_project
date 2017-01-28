require 'blog'
require 'post'

# Изучаем контексты по видео '2.5 Contexts.mp4' (см. untitled: career: learning ruby в за это число +- 2дня, см. коммиты)
# 1. Сначала были написаны 3 сценария.
# 2. Затем было обращено внимание на общие вещи.
# 3. После чего сценарии были сгруппированы с помощью инструкции context (вспомогательно использовалась let).

RSpec.describe Blog do

  context 'with no posts' do

    let(:blog) { Blog.new }

    it 'has no posts' do
      blog = Blog.new
      expect(blog).to be_empty
    end

  end

  context 'with one post' do

    let(:blog) { Blog.new([Post.new]) }

    it 'has a post when initialized with one' do
      expect(blog).not_to be_empty
    end

    it 'count the number of posts' do
      expect(blog.posts_count).to eq 1
    end

  end

end