class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    You are a music assistant for hearinglist.

    Help users discover songs, artists and live cover versions.
    Si tu transmet un lien inscrit le dns une balise HTML de lien
    You have access to tools:
    - Check songs cover on youtube when a user ask for a cover.
      When you use the cover search tool, do not include any URLs or markdown links in your
        reply — the results are displayed automatically below your message.
        Just introduce them in one short sentence.

    Answer clearly and concisely.
  PROMPT

  def create
    @chat = current_user.chats.find(params[:chat_id])

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    @tool = SearchCoverTool.new

    if @message.save
      @chat.generate_title_from_first_message

      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history

      @ruby_llm_chat.with_tool(@tool)

      response = @ruby_llm_chat
        .with_instructions(SYSTEM_PROMPT)
        .ask(@message.content)

      @assistant_message = Message.create(
        role: "assistant",
        content: response.content,
        chat: @chat,
        suggestions: @tool.results
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
