require "test_helper"

class ChatTest < ActiveSupport::TestCase
  test "est valide avec un titre" do
    assert Chat.new(title: "Reprises 90s", user: users(:alice)).valid?
  end

  test "est valide sans titre" do
    assert Chat.new(user: users(:alice)).valid?
  end

  test "est invalide sans user" do
    assert_not Chat.new(title: "Orphelin").valid?
  end

  test "refuse un titre trop long" do
    assert_not Chat.new(title: "a" * 121, user: users(:alice)).valid?
  end
end
