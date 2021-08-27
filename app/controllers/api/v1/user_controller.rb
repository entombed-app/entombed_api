class Api::V1::UserController < ApplicationController
  def show
    user = User.find(params[:id])
    render json: UserSerializer.new(user)
  end
end