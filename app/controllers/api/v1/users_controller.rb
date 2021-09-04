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
    user = User.update(params[:id], user_params)
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

  # def profile_picture
  #   user = User.find(params[:user_id])
  #   attach_picture(user)
  #   render json: UserSerializer.new(user)
  # end

  private

  def user_params
    params.permit(:email, :date_of_birth, :name, :obituary, :password, :profile_picture)
  end

  # def attach_picture(profile)
  #   profile.profile_picture.attach(
  #     io: File.open(params[:profile_picture][:io]),
  #     filename: params[:profile_picture][:filename],
  #     content_type: params[:profile_picture][:content_type]
  #   )
  #end
end

# user_1.profile_picture.attach(
#   io: File.open('./public/profile_pictures/profile-picture.png'),
#   filename: 'profile-picture.png',
#   content_type: 'application/png'
#)