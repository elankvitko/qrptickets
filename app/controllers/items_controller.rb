class ItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @unread = mailbox.inbox(:unread => true).count

    if current_user.order_admin
      @items = Item.all.sort_by { |obj| obj.created_at }.reverse
    else
      @items = Item.where( user_id: current_user.id ).sort.reverse
    end
  end

  def new
    @unread = mailbox.inbox(:unread => true).count
    @item = Item.new
  end

  def create
    @item = Item.new( item_params )

    if @item.save
      OrdersMailer.new_order.deliver_now

      redirect_to items_path
    end
  end

  def update
    @item = Item.find( params[ 'id' ] )

    if request.xhr?
      if params[ 'status' ] == 'delete'
        @item.destroy
      elsif params[ 'status' ] == 'Ordered'
        @item.update_attributes( status: "Ordered" )
      end
      redirect_to items_path
    end
  end

    private

    def item_params
      params.require( :item ).permit( :name, :qty, :location, :user_id )
    end
end
