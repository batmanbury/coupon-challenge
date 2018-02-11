class UsersDatatable < AjaxDatatablesRails::Base
  def view_columns
    @view_columns ||= {
      name: { source: "User.name" },
      email: { source: "User.email" },
      joined_on: { source: "User.created_at" },
      requested_coupons: { source: "User.requested_coupons", orderable: false, searchable: false },
      posted_coupons: { source: "User.posted_coupons", orderable: false, searchable: false },
      balance: { source: "User.balance" }
    }
  end

  private

  def data
    records.map do |user|
      {
        name: user.name,
        email: user.email,
        joined_on: user.created_at,
        requested_coupons: user.requested_coupons.count,
        posted_coupons: user.posted_coupons.count,
        balance: user.usd_balance,
      }
    end
  end

  def get_raw_records
    User.includes(:requested_coupons, :posted_coupons).references(:requested_coupons, :posted_coupons)
  end
end
