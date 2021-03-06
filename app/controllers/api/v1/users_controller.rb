class Api::V1::UsersController < ApplicationController
  def create
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

  def update
    user = User.find(params[:id])
    user.update(user_params)
    if user.valid?
      render json: UserSerializer.new(user), status: 200
    else
      render json: {
        error: 'User name, email, birthdate cannot be empty'
      }, status: 400
    end
  end

  def show
    user = User.find(params[:id])
    render json: UserSerializer.new(user)
  end

  def profile_picture
    user = User.find(params[:user_id])
    if params[:profile_picture]
      user.profile_picture.purge
      user.profile_picture.attach(params[:profile_picture])
      render json: UserSerializer.new(user)
    else
      render json: {
        error: 'No image file detected'
      }, status: 400
    end
  end

  def email
    user = User.find(params[:user_id])
    if params[:user_url]
      user_url = params[:user_url]
      UserMailer.send_email(user, user_url).deliver_later
    else
      render json: {
        error: 'No memorial url detected'
      }, status: 400
    end  
  end

  private

  def user_params
    params.permit(:email, :date_of_birth, :name, :obituary, :password, :profile_picture, :user_url, :user_etd)
  end
end
