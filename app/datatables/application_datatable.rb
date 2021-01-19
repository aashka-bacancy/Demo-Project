# frozen_string_literal: true

class ApplicationDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable
  include ActionView::Helpers::UrlHelper
  def_delegator :@view, :link_to
  def_delegator :@view, :asset_pack_path
  def_delegator :@view, :image_tag
  def_delegator :@view, :content_tag
  def_delegator :@view, :concat
  def_delegator :@view, :html_safe

  def initialize(view, other_object_value)
    @view = view
    @other_object_value = other_object_value
  end

  def as_json(_options = {})
    {
      recordsTotal: count || 0,
      recordsFiltered: total_entries || 0,
      data: data || []
    }
  end

  

  private

  def page
    @view.params[:start].to_i / per_page + 1 if @view.params[:start].present?
  end

  def per_page
    @view.params[:length].to_i > 0 ? @view.params[:length].to_i : 25 if @view.params[:length].present?
  end

  def sort_column(sortable_columns)
    if sortable_columns[@view.params[:order]["0"][:column].to_i].is_a?(Hash)
      sortable_columns[@view.params[:order]['0'][:column].to_i][:search] if @view.params[:order].present?
    else
      sortable_columns[@view.params[:order]['0'][:column].to_i] if @view.params[:order].present?
    end
  end

  def sort_direction
    @view.params[:order]['0'][:dir] == 'asc' ? 'desc' : 'asc' if @view.params[:order].present?
  end

  def show_link(view_link)
    link_to view_link, class: 'blue-color w-35 h-35 rounded d-flex align-items-center justify-content-center mx-1 icon-img','data-toggle': 'popover', 'data-placement': 'top', 'title': 'Show Users' do
      image_tag(asset_pack_path('media/images/member.svg'))
    end
  end

  def edit_link(view_link)
    link_to view_link, class: 'light-blue-color w-35 h-35 rounded d-flex align-items-center justify-content-center mx-1 icon-img','data-toggle': 'popover', 'data-placement': 'top', 'title': 'Edit' do
      image_tag(asset_pack_path('media/images/edit.svg'))
    end
  end

  def destroy_link(view_link)
    link_to view_link, class: 'red-color w-35 h-35 rounded d-flex align-items-center justify-content-center mx-1 icon-img', method: :delete, data: { confirm:"Are you sure you want to delete it?" },'data-toggle': 'popover', 'data-placement': 'top', 'title': 'Delete' do
      image_tag(asset_pack_path('media/images/delete.svg'))
    end
  end
end
