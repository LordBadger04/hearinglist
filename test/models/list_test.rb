require "test_helper"

class ListTest < ActiveSupport::TestCase
  test "est valide avec un titre et un user" do
    assert List.new(title: "Acoustique", user: users(:alice)).valid?
  end

  test "est invalide sans titre" do
    list = List.new(title: nil, user: users(:alice))
    assert_not list.valid?
    assert_includes list.errors[:title], "can't be blank"
  end

  test "est invalide sans user" do
    assert_not List.new(title: "Orpheline").valid?
  end

  test "refuse deux listes du meme nom pour le meme user" do
    assert_not List.new(title: "Mes favoris", user: users(:alice)).valid?
  end

  test "autorise le meme nom de liste chez deux users differents" do
    assert List.new(title: "Mes favoris", user: users(:bob)).valid?
  end
end
