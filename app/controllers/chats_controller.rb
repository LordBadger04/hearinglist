class ChatsController < ApplicationController
  def create
    @chat = Chat.new(chat_params)
    @chat.user = current_user
    if @chat.save
      redirect_to chat_path(@chat)
    else
      render :show, status: :unprocessable_entity
    end
  end

  def show
    @chat = Chat.find(params[:id])
  end

  private

  def chat_params
    params.require(:chat).permit(:title)
  end
end
