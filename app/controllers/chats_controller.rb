class ChatsController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = Chat.new(title: "Untitled")
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      redirect_to root_path, alert: "Unable to create chat."
    end
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end
end
