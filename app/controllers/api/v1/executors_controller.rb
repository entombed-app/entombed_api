class Api::V1::ExecutorsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    exec = user.executors.new(executor_params)
    if exec.save
      render json: ExecutorSerializer.new(exec), status: 201
    else
      render json: {
        error: 'Missing or Incorrect Executor Params'
      }, status: 400
    end
  end

  def update
    executor = Executor.update(params[:id], executor_params)
    if executor.valid?
      render json: ExecutorSerializer.new(executor), status: 200
    else
      render json: {
        error: 'Executor name or email cannot be empty'
      }, status: 400
    end
  end

  private

  def executor_params
    params.permit(:email, :name, :phone)
  end
end