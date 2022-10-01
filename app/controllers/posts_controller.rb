# frozen_string_literal: true

class PostsController < ApiController
  before_action :authenticate_v1_user!, except: %i[index]
  def index
    render json: { posts: Post.limit(50) }
  end
end
