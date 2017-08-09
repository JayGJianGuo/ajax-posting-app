class PostsController < ApplicationController

  before_action :authenticate_user!, :only => [:create, :destroy]

  def index
    @posts = Post.order("id DESC").all
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save

  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy

  end

  def like
    @post = Post.find(params[:id])
    unless @post.find_like(current_user)  # 如果已经按讚过了，就略过不再新增
      Like.create( :user => current_user, :post => @post)
    end

  end

  def unlike
    @post = Post.find(params[:id])
    like = @post.find_like(current_user)
    like.destroy

    render "like"
  end

  def collection
    @post = Post.find(params[:id])
    unless collection = @post.find_collection(current_user)
      Collection.create( :user => current_user, :post => @post )
    end
  end

  def uncollecte
    @post = Post.find(params[:id])
    collection = @post.find_collection(current_user)
    collection.destroy

    render "collection"
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
