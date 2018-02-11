class TransfersController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_revenue = Transfer.sum(:commission_amount)
  end

  def as_json
    render json: TransfersDatatable.new(view_context, {})
  end
end
