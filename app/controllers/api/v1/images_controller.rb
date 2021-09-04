class Api::V1::ImagesController < ApplicationController
  def create
    user = User.find(params[:user_id])
    if params[:image] && params[:image].class != String
      user.images.attach(params[:image])
      render json: UserSerializer.new(user), status: 201
    else
      render json: {
        error: 'No image file detected'
      }, status: 400
    end
  end
end