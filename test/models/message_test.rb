require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "est valide avec un role connu et du contenu" do
    assert Message.new(role: "user", content: "Salut", chat: chats(:alice_chat)).valid?
  end

  test "est invalide sans contenu" do
    message = Message.new(role: "user", content: "", chat: chats(:alice_chat))
    assert_not message.valid?
    assert_includes message.errors[:content], "can't be blank"
  end

  test "refuse un role inconnu" do
    message = Message.new(role: "robot", content: "Salut", chat: chats(:alice_chat))
    assert_not message.valid?
    assert_includes message.errors[:role], "is not included in the list"
  end

  test "est invalide sans chat" do
    assert_not Message.new(role: "user", content: "Salut").valid?
  end
end
