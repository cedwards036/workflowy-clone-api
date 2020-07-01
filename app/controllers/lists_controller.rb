class ListsController < ApplicationController
  before_action :set_list, only: [:show]

  def show
    render json: @list.as_json(methods: [:child_nodes, :tag_names]), status: :ok
  end

  def create
    @list = List.create!(list_params)
    render json: @list.as_json(methods: [:child_nodes, :tag_names]), status: :created
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:show_completed)
  end
end
