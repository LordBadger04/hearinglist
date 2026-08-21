class AddToListTool < RubyLLM::Tool
  description "Add a given version to a list"
  param :version_id, desc: "The ID of the version", type: :integer
  param :list_title, desc: "The title of the list"


  def execute(version_id:, list_title:)
    list = List.find_by(title: list_title.capitalize)
    version = Version.find(version_id)
    Bookmark.create!(
      list: list,
      version: version
    )

  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end
end
