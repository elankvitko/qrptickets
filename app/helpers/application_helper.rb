module ApplicationHelper
  def active_page(active_page)
    @active == active_page ? "active" : ""
  end

  def find_me( email )
    me = USERS.select { |obj| obj[ 'profile' ][ 'email' ] == email }

    if me.empty?
      return false
    else
      my_picture = me.first[ 'profile' ][ 'image_192' ]
    end
  end
end
