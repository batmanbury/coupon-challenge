//= require datatables.min
//= require export

$(document).on('coupons#index:loaded', function() { loadCoupons(); });

function loadCoupons() {
  if ($.fn.dataTable.isDataTable('#coupons-table')) {
    var coupons_table = $('#coupons-table').DataTable();
  } else {
    var coupons_table = $('#coupons-table').DataTable({
      processing:     true,
      serverSide:     true,
      ajax:           { url: "/coupons/as_json", type: "POST" },
      order:          [[2, 'desc']],
      dom:            '<<"table-header">Bfltrip>',
      // On small-width screens, enable horizontal scrolling
      scrollX:        true,
      scrollCollapse: true,
      "oLanguage": { "oPaginate": { "sNext": "»", "sPrevious": "«" } },
      columns: [
        { data: 'brand' },
        { data: 'value' },
        { data: 'posted_on' },
        { data: 'posted_by' },
        { data: 'request' },
      ],
      buttons: [{
        extend: 'excel',
        className: 'excel-export-btn',
        text: 'Export Coupons',
        action: newExportAction,
        exportOptions: {
          columns: [0,1,2,3],
          orthogonal: 'export'
        }
      }]
    });
    // Fix right-most request coupon column
    new $.fn.dataTable.FixedColumns(coupons_table, {
      leftColumns: 0,
      rightColumns: 1
    });
    $("div.table-header").html('<h1>Available Coupons</h1>');
  }
  // // Grab It!
  // $(document).on('click', '.request-coupon-btn', function() {
  //   var coupon_id = $(this).data('coupon-id');
  //   console.log(coupon_id);
  // });
}
