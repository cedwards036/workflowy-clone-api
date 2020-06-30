class ListsController < ApplicationController
  before_action :set_list, only: [:show]

  def show
    render json: @list.as_json(methods: [:nodes, :child_nodes]), status: :ok
  end

  def create
    @list = List.create!(list_params)
    render json: @list, status: :created
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:show_completed)
  end
end
