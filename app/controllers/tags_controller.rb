class TagsController < ApplicationController
  before_action :set_tag, only: :show

  def index
    @tags = Tag.find_by(name: params[:name], list_id: params[:list_id])
    render json: @tags, status: :ok
  end

  def show
    render json: @tag, status: :ok
  end

  def set_tag
    @tag = Tag.find(params[:id])
  end
end
