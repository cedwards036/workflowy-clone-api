class TagsController < ApplicationController
  before_action :set_tag, only: :show

  def index
    @tags = Tag.find_by(name: params[:name], list_id: params[:list_id])
    render json: @tags, status: :ok
  end

  def show
    render json: @tag, status: :ok
  end

  def create
    list = List.find(params[:list_id])
    @tag = list.tags.build(tag_params)
    @tag.save
    render json: @tag, status: :created
  end

  private 

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
