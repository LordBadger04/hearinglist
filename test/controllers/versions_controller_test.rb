require "test_helper"

class VersionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:alice)
    @list = lists(:alice_favorites)
    sign_in @user
  end

  def valid_params(overrides = {})
    { version: {
      song_title: "Redemption Song",
      artist_name: "Bob Marley",
      year: "1980",
      style: "acoustic"
    }.merge(overrides) }
  end

  test "exige une authentification" do
    sign_out @user
    get new_version_path
    assert_redirected_to new_user_session_path
  end

  test "affiche le formulaire" do
    get new_version_path
    assert_response :success
  end

  test "cree la song, l'artist et la version d'un seul coup" do
    assert_difference [ "Song.count", "Artist.count", "Version.count" ], 1 do
      post versions_path, params: valid_params
    end

    version = Version.order(:id).last
    assert_equal "Redemption Song", version.song.title
    assert_equal "Bob Marley", version.artist.name
    assert_equal 1980, version.year
    assert_equal "acoustic", version.style
  end

  test "reutilise une song et un artist deja en base" do
    song = songs(:hallelujah)
    artist = artists(:cohen)

    assert_no_difference [ "Song.count", "Artist.count" ] do
      assert_difference "Version.count", 1 do
        post versions_path, params: valid_params(song_title: song.title, artist_name: artist.name)
      end
    end

    version = Version.order(:id).last
    assert_equal song.id, version.song_id
    assert_equal artist.id, version.artist_id
  end

  test "ignore les espaces autour des champs texte" do
    post versions_path, params: valid_params(song_title: "  Hallelujah  ", artist_name: "  Leonard Cohen  ")
    assert_equal songs(:hallelujah).id, Version.order(:id).last.song_id
  end

  test "refuse un formulaire vide sans rien laisser en base" do
    assert_no_difference [ "Song.count", "Artist.count", "Version.count" ] do
      post versions_path, params: valid_params(song_title: "", artist_name: "", style: "")
    end

    assert_response :unprocessable_entity
  end

  test "n'enregistre pas d'artist orphelin quand la song echoue" do
    assert_no_difference [ "Song.count", "Artist.count" ] do
      post versions_path, params: valid_params(song_title: "")
    end
  end

  test "refuse un style hors de la liste autorisee" do
    assert_no_difference "Version.count" do
      post versions_path, params: valid_params(style: "karaoke")
    end
    assert_response :unprocessable_entity
  end

  test "renvoie vers la liste d'origine quand list_id est fourni" do
    post versions_path, params: valid_params.merge(list_id: @list.id)
    assert_redirected_to new_list_bookmark_path(@list)
  end

  test "renvoie vers l'accueil sans list_id" do
    post versions_path, params: valid_params
    assert_redirected_to root_path
  end
end
