class VersionsController < ApplicationController
  def new
    @version = Version.new
  end

  def create
    @list = List.find(params[:list_id])
    @version = Version.new(version_params)
    if @version.save
      redirect_to list list_path(@list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def version_params
    params.require(:version).permit(:style, :version_url, :year)
  end
end
