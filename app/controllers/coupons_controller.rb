class CouponsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
  end

  def new
  end

  def destroy
  end

  def request_coupon
    coupon = Coupon.find(params[:id])
    requester = current_user
    cts = CouponTransferService.new(coupon, requester)
    successful = cts.transfer!
    if successful
      flash[:notice] = "You just grabbed a #{coupon.usd_value} coupon for #{coupon.brand.name}!"
    else
      flash[:danger] = cts.errors.messages.values.flatten.join(' ')
    end
    redirect_to coupons_path
  end

  def as_json
    render json: CouponsDatatable.new(view_context, { authtoken: session[:_csrf_token] })
  end
end
