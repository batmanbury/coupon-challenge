//= require datatables.min
//= require export

$(document).on('transfers#index:loaded', function() { loadTransfers(); });

function loadTransfers() {
  if ($.fn.dataTable.isDataTable('#transfers-table')) {
    var transfers_table = $('#transfers-table').DataTable();
  } else {
    var transfers_table = $('#transfers-table').DataTable({
      processing:     true,
      serverSide:     true,
      ajax:           { url: "/transfers/as_json", type: "POST" },
      order:          [[3, 'desc']],
      dom:            '<<"table-header">Bfltrip>',
      "oLanguage": { "oPaginate": { "sNext": "»", "sPrevious": "«" } },
      columns: [
        { data: 'poster' },
        { data: 'requester' },
        { data: 'coupon_id' },
        { data: 'occurred_on' },
        { data: 'commission' }
      ],
      buttons: [{
        extend: 'excel',
        className: 'excel-export-btn',
        text: 'Export Transactions',
        action: newExportAction,
        exportOptions: {
          orthogonal: 'export'
        }
      }]
    });
    var total_revenue = $('#transfers-table').data('total-revenue');
    $("div.table-header").html('<h1>Transaction History</h1><h5>Total Revenue: ' + total_revenue + '</h5>');
  }
}
