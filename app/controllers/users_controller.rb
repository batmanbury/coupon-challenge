class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def as_json
    render json: UsersDatatable.new(view_context, {})
  end

  def create_charge
    user = current_user
    stripe = stripe_params
    # Create/Retrieve Stripe Customer
    if user.stripe_customer_id.nil?
      customer = Stripe::Customer.create(
        :email => stripe[:email],
        :source  => stripe[:token_id]
      )
      user.stripe_customer_id = customer.id
      user.save
    else
      customer = Stripe::Customer.retrieve(user.stripe_customer_id)
      customer.source = stripe[:token_id]
      customer.save
    end
    # Create Stripe Charge
    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => 2000,
      :description => 'Coupon Marketplace $20 Deposit',
      :currency    => 'usd'
    )

    respond_to do |format|
      if !!charge # If a charge object is created, it was successful
        user.credit_to_balance(charge.amount/100)
        flash.keep[:notice] = "Deposit successful!"
        msg = { status: 200 }
      else
        flash.keep[:danger] = "There was a problem processing your credit card."
        msg = { status: 422 }
      end
      format.json { render json: msg }
    end

  rescue Stripe::CardError => e
    flash.keep[:danger] = "There was a problem processing your credit card. #{e.message}"
    respond_to do |format|
      msg = { status: 422 }
      format.json { render json: msg }
    end
  end

  private

  def stripe_params
    params.require(:stripe).permit(:token_id, :email)
  end
end
