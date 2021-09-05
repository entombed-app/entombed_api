class Api::V1::RecipientsController < ApplicationController
    def index
      user = User.find(params[:user_id])
      recipients = user.recipients
      render json: RecipientSerializer.new(recipients)
    end
  
    def create
      user = User.find(params[:user_id])
      recipient = user.recipients.new(recipient_params)
      if recipient.save
        render json: RecipientSerializer.new(recipient), status: 201
      else
        render json: {
          error: 'Missing or Incorrect Recipient Params'
        }, status: 400
      end
    end
  
    def update
      recipient = Recipient.update(params[:id], recipient_params)
      if recipient.valid?
        render json: RecipientSerializer.new(recipient), status: 200
      else
        render json: {
          error: 'Recipient name or email cannot be empty'
        }, status: 400
      end
    end
  
    def destroy
      Recipient.destroy(params[:id])
    end
  
    private
  
    def recipient_params
      params.permit(:email, :name)
    end
  end