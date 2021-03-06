class ListsController < ApplicationController
  before_action :set_list, only: [:show, :update]

  def show
    render json: @list.as_json(methods: [:root_node_id, :nodes, :tag_names, :child_ids]), status: :ok
  end

  def create
    @list = List.create!(list_params)
    root_node = @list.nodes.create!({text: "My List", completed: false, expanded: false})
    @list.root_node = root_node
    render json: @list.as_json(methods: [:root_node_id, :nodes, :tag_names, :child_ids]), status: :created
  end

  def update
    @list.update!(list_params)
    head :no_content
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:show_completed)
  end
end
