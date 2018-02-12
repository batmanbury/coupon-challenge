//= require datatables.min
//= require export

$(document).on('users#index:loaded', function() { loadUsers(); });

function loadUsers() {
  if ($.fn.dataTable.isDataTable('#users-table')) {
    var users_table = $('#users-table').DataTable();
  } else {
    var users_table = $('#users-table').DataTable({
      processing:     true,
      serverSide:     true,
      ajax:           { url: "/users/as_json", type: "POST" },
      order:          [[2, 'desc']],
      dom:            '<<"table-header">Bfltrip>',
      "oLanguage": { "oPaginate": { "sNext": "»", "sPrevious": "«" } },
      columns: [
        { data: 'name' },
        { data: 'email' },
        { data: 'joined_on' },
        { data: 'requested_coupons', orderable: false, searchable: false },
        { data: 'posted_coupons', orderable: false, searchable: false },
        { data: 'balance' }
      ],
      buttons: [{
        extend: 'excel',
        className: 'btn-outline-dark',
        text: 'Export Users',
        action: newExportAction,
        exportOptions: {
          orthogonal: 'export'
        }
      }]
    });
    $("div.table-header").html('<h1>Registered Users</h1>');
  }
}
