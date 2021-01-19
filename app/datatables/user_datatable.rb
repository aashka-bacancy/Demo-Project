class UserDatatable < ApplicationDatatable
  def_delegator :@view, :edit_user_path
  def_delegator :@view, :user_path
  def_delegator :@view, :content_tag
  def_delegator :@view, :concat

  def initialize(view)
    @view = view
  end

  def count
    users.count
  end

  def fetch_users
    search_string = []
    columns.map {|term| search_string << "#{term} like :search" }
    users = User.all.order(sort_column(sortable_columns))
    # for searching
    if @view.params.present? && @view.params[:search][:value].present?
      users = search_record(users, search_string)
    end

    # for filter
    search_string = filter_record
    if search_string.present?
      users = users.where(search_string.join(' AND ') )
    end

    users.page(page).per(per_page)

  end

  def search_record(users, search_string)
    users.where(search_string.join(' or '), search: "%#{@view.params[:search][:value]}%" )
  end

  def filter_record
    column_search = []
    @view.params[:columns].each do |key, val|
      column_search << {id: key, val: val[:search][:value]} if val[:search][:value].present?
    end
    search_string = []
    column_search.map { |key| search_string << "#{filter_columns[key[:id].to_i]} = #{key[:val]}" }
  end

  def users
    @users ||= fetch_users
  end

  def total_entries
    users.total_count
  end

  def data
    users.map do |u|
      [
        u.id,
        u.first_name,
        u.last_name,
        u.email,
        u.phone_number,
        u.gender,
        content_tag(:div, class: 'image') do
          if u.image.attached?
            image_tag(u.image)
          else
            image_tag(asset_pack_path('media/images/profile.png'))
          end
        end,
        content_tag(:div, class: 'd-flex w-100') do
          concat(show_link(user_path(id: u)))
          concat(edit_link(edit_user_path(id: u)))
          concat(destroy_link(user_path(id: u)))
        end
      ]
    end
  end

  def columns
    [
      'users.id',
      'users.first_name',
      'users.last_name',
      'users.email',
      'users.phone_number',
      'users.gender'
    ]
  end

  def filter_columns
    [
      'users.id',
      'users.first_name',
      'users.last_name',
      'users.email',
      'users.phone_number',
      'users.gender'
    ]
  end


  def sortable_columns
    # Todo filter assign task wise
    [
      'users.id',
      'users.first_name',
      'users.last_name',
      'users.email',
      'users.phone_number',
      'users.gender'
    ]
  end

end
