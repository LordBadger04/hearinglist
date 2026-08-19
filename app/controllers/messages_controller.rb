class MessagesController < ApplicationController
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
      @chat.generate_title_from_first_message

      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history

      response = @ruby_llm_chat
        .with_instructions(SYSTEM_PROMPT)
        .ask(@message.content)

      @assistant_message = Message.create(
        role: "assistant",
        content: response.content,
        chat: @chat
      )

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "new_message_container",
            partial: "messages/form",
            locals: { chat: @chat, message: @message }
          )
        end

        format.html do
          render "chats/show", status: :unprocessable_entity
        end
      end
    end
  end

  private

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
