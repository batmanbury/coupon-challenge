class CouponsDatatable < AjaxDatatablesRails::Base
  def view_columns
    @view_columns ||= {
      brand: { source: "Brand.name" },
      value: { source: "Coupon.value" },
      posted_on: { source: "Coupon.created_at" },
      posted_by: { source: "User.name" },
      request: { source: "Coupon.id", searchable: false, orderable: false }
    }
  end

  def data
    records.map do |coupon|
      {
        brand: coupon.brand.name,
        value: coupon.usd_value,
        posted_on: coupon.created_at,
        posted_by: coupon.poster.name,
        request: (
          "<form action='/coupons/#{coupon.id}/request_coupon' method='post'>
            <input type='hidden' name='authenticity_token' value='#{options[:authtoken]}'>
            <button type='submit' class='btn btn-success' data-disable-with='Grabbing'>Grab It!</button>
          </form>"
        ).html_safe
      }
    end
  end

  private

  def get_raw_records
    Coupon.posted.includes(:poster, :brand).references(:poster, :brand)
  end
end
