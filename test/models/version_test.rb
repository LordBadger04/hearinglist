require "test_helper"

class VersionTest < ActiveSupport::TestCase
  # NOTE: ce fichier visait les colonnes `url` et `type` de la PR #9. Elles ont
  # ete renommees en `version_url` et `style` sans que les tests suivent, ce qui
  # cassait toute la suite. Les tests de validation d'URL (presence, format,
  # unicite) ont ete retires : ces validations n'existent plus sur le modele.
  # Faut-il les restaurer ? -> voir l'issue ouverte a ce sujet.

  def build_version(attrs = {})
    Version.new({
      version_url: "https://example.com/une-nouvelle-version",
      style: "live",
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

  test "refuse un style hors de la liste autorisee" do
    version = build_version(style: "karaoke")
    assert_not version.valid?
    assert_includes version.errors[:style], "is not included in the list"
  end

  test "refuse un style vide" do
    assert_not build_version(style: nil).valid?
  end

  test "accepte tous les styles de la liste autorisee" do
    Version::STYLES.each do |style|
      assert build_version(style: style).valid?, "#{style} devrait etre un style valide"
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

  test "ne traite pas style comme une colonne d'heritage" do
    assert Version.inheritance_column.blank?
  end
end
