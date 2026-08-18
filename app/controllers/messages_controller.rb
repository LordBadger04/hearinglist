class MessagesController < ApplicationController
  before_action :authenticate_user!

  SYSTEM_PROMPT = <<~PROMPT
    You are a music assistant for hearinglist.

    Help users discover songs, artists and live cover versions.

    Answer clearly and concisely.
  PROMPT

  def create
    @chat = current_user.chats.find(params[:chat_id])

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      response = RubyLLM.chat
        .with_instructions(SYSTEM_PROMPT)
        .ask(@message.content)

      Message.create(
        role: "assistant",
        content: response.content,
        chat: @chat
      )

      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
