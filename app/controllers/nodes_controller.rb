class NodesController < ApplicationController
  before_action :set_node, only: [:show, :update, :destroy]

  def show
    render json: @node.as_json(methods: [:tag_names])
  end

  def create
    parent_node = Node.find(node_params[:parent_node_id])
    @node = parent_node.children.create!(creation_params)
    render json: @node.as_json(methods: [:tag_names]), status: :created
  end

  def update
    @node.update!(update_params(@node.list_id))
    head :no_content
  end

  def destroy
    @node.destroy
    head :no_content
  end

  private

  def update_params(list_id)
    params_copy = node_params.except(:tag_names)
    params_copy[:tags] = resolve_tag_names(node_params[:tag_names], list_id)
    return params_copy
  end

  def creation_params
    params_copy = update_params(params[:list_id])
    params_copy[:list_id] = params[:list_id]
    return params_copy
  end

  def resolve_tag_names(tag_names, list_id) 
    tag_names.map do |tag_name|
      Tag.find_or_create_by!(name: tag_name, list: List.find(list_id))
    end
  end

  def node_params
    params.require(:node).permit(:text, :completed, :expanded, :parent_node_id, 
      :tag_names => [])
  end

  def set_node
    @node = Node.find(params[:id])
  end
end
