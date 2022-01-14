class MessagesController < ApplicationController
  before_action :set_user, only: [:index]

  def index
    messages = MessageFilterService.new(@user, message_params).filter
    render json: messages
  end

  def create
    message = Message.new(message_params)

    if message.save
      render json: message, status: :created
    else
      render json: message.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def message_params
    params.permit(:sender_id, :recipient_id, :body)
  end
end
