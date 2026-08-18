require "test_helper"

class SongTest < ActiveSupport::TestCase
  test "est valide avec un titre" do
    assert Song.new(title: "Wish You Were Here").valid?
  end

  test "est invalide sans titre" do
    song = Song.new(title: nil)
    assert_not song.valid?
    assert_includes song.errors[:title], "can't be blank"
  end

  test "refuse un titre deja pris, meme avec une casse differente" do
    assert_not Song.new(title: "hallelujah").valid?
  end
end
