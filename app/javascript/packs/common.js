$(document).on('turbolinks:load', function(){
  datatable = $('#users-datatable').dataTable({
    processing: true,
    serverSide: true,
    bFilter: true,
    ajax: {
      url: $('.dataTable').data('url')
    },
    pageLength: 25,
    columnDefs: [
      { order: [ 0, 'asc' ] },
      { "targets": 'no-sort',
      "orderable": false },
    ],
    drawCallback: function( settings ) {
    }
  });
  
  $('#search').on( 'keyup', function () {
    datatable.api().search($(this).val()).draw();
  } );
})