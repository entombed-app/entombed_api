class Api::V1::UsersController < ApplicationController
  def create
    if params[:password] != params[:password_confirmation]
      render json: {
        error: 'password and confirmation must match', 
        status: 401
      }, status: 401
    else
      user = User.new(user_params)
      if user.save
        render json: UserSerializer.new(user).serializable_hash.to_json, status: 201
      else
        render json: {
          error: 'Missing or incorrect user params',
          status: 400
        }, status: 400
      end
    end
  end

  private

  def user_params
    params.permit(:email, :date_of_birth, :name, :obituary,:password, :profile_picture)
  end
end