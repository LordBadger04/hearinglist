require "test_helper"

class VersionTest < ActiveSupport::TestCase
  def build_version(attrs = {})
    Version.new({
      url: "https://example.com/une-nouvelle-version",
      type: "live",
      year: 1994,
      artist: artists(:cohen),
      song: songs(:hurt)
    }.merge(attrs))
  end

  test "est valide avec tous les attributs attendus" do
    assert build_version.valid?
  end

  test "est invalide sans artiste ni chanson" do
    version = build_version(artist: nil, song: nil)
    assert_not version.valid?
    assert_includes version.errors[:artist], "must exist"
    assert_includes version.errors[:song], "must exist"
  end

  test "refuse une url qui n'est pas un lien http" do
    version = build_version(url: "youtube.com/watch")
    assert_not version.valid?
    assert_includes version.errors[:url], "doit commencer par http:// ou https://"
  end

  test "refuse une url deja enregistree" do
    assert_not build_version(url: versions(:cohen_studio).url).valid?
  end

  test "refuse un type hors de la liste autorisee" do
    version = build_version(type: "karaoke")
    assert_not version.valid?
    assert_includes version.errors[:type], "is not included in the list"
  end

  test "accepte tous les types de la liste autorisee" do
    Version::KINDS.each do |kind|
      assert build_version(type: kind).valid?, "#{kind} devrait etre un type valide"
    end
  end

  test "refuse une annee dans le futur" do
    assert_not build_version(year: Date.current.year + 1).valid?
  end

  test "refuse une annee avant le premier enregistrement connu" do
    assert_not build_version(year: 1700).valid?
  end

  test "accepte une annee vide" do
    assert build_version(year: nil).valid?
  end

  test "ne traite pas type comme une colonne d'heritage" do
    assert Version.inheritance_column.blank?
  end
end
