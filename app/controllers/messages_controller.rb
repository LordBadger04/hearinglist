class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)

    @message.chat = @chat
    @message.user = current_user

    if @message.save
      redirect_to message_path(@message)
    else
      render :show, status: :unprocessable_entity
    end
  end
end
