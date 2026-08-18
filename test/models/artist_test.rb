require "test_helper"

class ArtistTest < ActiveSupport::TestCase
  test "est valide avec un nom" do
    assert Artist.new(name: "Nina Simone").valid?
  end

  test "est invalide sans nom" do
    artist = Artist.new(name: "")
    assert_not artist.valid?
    assert_includes artist.errors[:name], "can't be blank"
  end

  test "refuse un nom deja pris, meme avec une casse differente" do
    assert_not Artist.new(name: "leonard cohen").valid?
  end
end
