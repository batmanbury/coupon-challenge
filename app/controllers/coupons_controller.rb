class CouponsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
  end

  def create
    brand_name = params[:coupon].delete(:brand_name)
    coupon = Coupon.new(coupon_params)
    if params[:coupon][:brand_id].blank?
      # create a Brand as well
      new_brand = Brand.where(name: brand_name).first_or_create
      coupon.brand_id = new_brand.id
    end
    if coupon.save
      flash[:notice] = "Successfully posted a coupon valued at #{coupon.usd_value} for #{coupon.brand.name}."
    else
      flash[:danger] = "There was an error with your coupon details."
    end
    redirect_to edit_user_registration_path
  end

  # Supply values for autocompletion in coupons#new
  def brand_select
    if params[:term]
      brands = Brand.where("name ~* ?", "#{params[:term]}")
    else
      brands = Brand.all
    end
    brands = brands.collect { |b| { label: b.name, value: b.id } }
    respond_to do |format|
      format.json { render :json => brands.to_json }
    end
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
    render json: CouponsDatatable.new(params.merge({ authtoken: session[:_csrf_token] }))
  end

  private

  def coupon_params
    params.require(:coupon).permit(:brand_id, :value, :poster_id)
  end
end
