require 'rubygems'
require 'sinatra'
require 'data_mapper' # metagem, requires common plugins too.

set :bind, '0.0.0.0'

# need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!

get '/' do
  # @post = Post.first
  # @post = Post.last
  @posts = Post.all
  erb :index
end

get '/create' do
  # File.open 대신 DB를 사용
  Post.create(
    # 해쉬형태로 키와 값을 넣어줌
    # :title => "날아온 제목",
    # :body => "날아온 내용",

    :title => params["title"],
    :body => params["content"],

  )
end
