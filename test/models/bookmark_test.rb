require "test_helper"

class BookmarkTest < ActiveSupport::TestCase
  test "est valide pour une version pas encore dans la liste" do
    assert Bookmark.new(list: lists(:alice_favorites), version: versions(:buckley_cover)).valid?
  end

  test "refuse deux fois la meme version dans la meme liste" do
    bookmark = Bookmark.new(list: lists(:alice_favorites), version: versions(:cohen_studio))
    assert_not bookmark.valid?
    assert_includes bookmark.errors[:version_id], "est deja dans cette liste"
  end

  test "autorise la meme version dans deux listes differentes" do
    assert Bookmark.new(list: lists(:bob_covers), version: versions(:cohen_studio)).valid?
  end
end
