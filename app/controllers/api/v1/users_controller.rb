class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    user.profile_picture.attach(user_params[:profile_picture])
    if user.save
      render json: UserSerializer.new(user).serializable_hash.to_json, status: 201
    else
      render json: {
        error: 'Missing or incorrect user params',
        status: 400
      }, status: 400
    end
  end

  def profile_picture
    user = User.find_by(id: params[:id])
  
    if user&.profile_picture&.attached?
      redirect_to rails_blob_url(user.profile_picture)
    else
      head :not_found
    end
  end

  private

  def user_params
    params.permit(:email, :date_of_birth, :name, :obituary, :password, :profile_picture)
  end
end