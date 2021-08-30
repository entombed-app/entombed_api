class Api::V1::UserController < ApplicationController
  def show
    user = User.find(params[:id])
    #profile_picture = rails_blob_path(user.profile_picture)
    render json: UserSerializer.new(user)
  end
end