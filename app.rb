require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper' # metagem, requires common plugins too.

set :bind, '0.0.0.0'

# need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
# Post 클래스라는 새로운 테이블을 하나 만들어서 이 형태는 다음과 같은 컬럼이 있다는 것을 선언
# Post, User라는 Datatable
class Post
  include DataMapper::Resource
  # property를 쓰고, 컬럼이름 쓰고, 자료형을 써서 선언한다.
  property :id, Serial
  property :title, String
  property :body, Text
  property :created_at, DateTime
end

class User
  include DataMapper::Resource
  # property를 쓰고, 컬럼이름 쓰고, 자료형을 써서 선언한다.
  property :id, Serial
  property :email, String
  property :password, String
  property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
# Post와User가 들어올때마다 자동업데이트
Post.auto_upgrade!
User.auto_upgrade!

get '/' do
  # @post = Post.first
  # @post = Post.last
  # 가장 최근 파일이 나올 수 있게 배열의 값을 거꾸로 뒤짚음
  @posts = Post.all.reverse
  erb :index
end

get '/create' do
  # File.open 대신 DB를 사용
  Post.create(
    # 해쉬형태로 키와 값을 넣어줌
    # :title => "날아온 제목",
    # :body => "날아온 내용",
    :title => params["title"],
    :body => params["content"]
  )
  # 바로 돌아가게 하는 메소드
  redirect to '/'
end

get '/sign_up' do
  erb :sign_up
end

get '/register' do
  User.create(
    # 해쉬형태로 키와 값을 넣어줌
    :email => params["email"],
    :password => params["password"]
  )
  redirect to '/'
end

get '/admin' do
  # 모든 유저 정보를 가져오기
  @users = User.all
  erb :admin
end
