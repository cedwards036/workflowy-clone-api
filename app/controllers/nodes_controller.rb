class NodesController < ApplicationController
  before_action :set_node, only: [:show, :update, :destroy]

  def show
    render json: @node.as_json(methods: [:tag_names])
  end

  def create
    if node_params.has_key? :parent_node_id
      create_node(Node.find(node_params[:parent_node_id]))
    elsif node_params.has_key? :parent_list_id
      create_node(List.find(node_params[:parent_list_id]))
    else
      render json: { message: "A node must have either a parent_node_id or a parent_list_id" }, status: :bad_request
    end
  end

  def update
    @node.update!(resolve_tag_names_in_params)
    head :no_content
  end

  def destroy
    @node.destroy
    head :no_content
  end

  private

  def create_node(node_parent)
    @node = node_parent.child_nodes.create!(resolve_tag_names_in_params)
    render json: @node.as_json(methods: [:tag_names]), status: :created
  end

  def resolve_tag_names_in_params
    params_copy = node_params.except(:tag_names)
    list_id = node_params[:list_id] || @node.list_id
    if node_params[:tag_names].any? && node_params[:tag_names] != [""]
      params_copy[:tags] = node_params[:tag_names].map do |tag_name|
        Tag.find_or_create_by!(name: tag_name, list: List.find(list_id))
      end
    end
    params_copy
  end

  def node_params
    params.require(:node).permit(:text, :completed, :expanded, :list_id, 
      :parent_node_id, :parent_list_id, :tag_names => [])
  end

  def set_node
    @node = Node.find(params[:id])
  end
end
