class Api::V1:SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email], password: params[:password])
  end
end