class TransfersDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    @view_columns ||= {
      poster: { source: 'Transfer.poster_name' },
      requester: { source: 'Transfer.requester_name' },
      coupon_id: { source: 'Transfer.coupon_id' },
      occurred_on: { source: 'Transfer.created_at' },
      commission: { source: 'Transfer.commission_amount' }
    }
  end

  def data
    records.map do |transfer|
      {
        poster: transfer.poster.try(:name),
        requester: transfer.requester.try(:name),
        coupon_id: transfer.coupon_id,
        occurred_on: transfer.created_at,
        commission: ActionController::Base.helpers.number_to_currency(transfer.commission_amount, precision: 2)
      }
    end
  end

  private

  def get_raw_records
    Transfer.includes(:poster, :requester, :coupon).references(:poster, :requester, :coupon)
  end
end
