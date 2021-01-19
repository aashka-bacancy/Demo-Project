$(document).on('turbolinks:load', function(){
  datatable = $('#users-datatable').dataTable({
    processing: true,
    serverSide: true,
    bFilter: true,
    ajax: {
      url: $('.dataTable').data('url')
    },
    language: {
      paginate: {
      }
    },
    "pageLength": 25,
    order: [[0, 'asc']],
    drawCallback: function( settings ) {
    }
  });
  
  $('.filter').on('change', function() {
    var val = $(this).val()
    datatable.api().column($(this).attr('id')).search(val ?  val : '').draw();
  });

  $('#search').on( 'keyup', function () {
    datatable.api().search($(this).val()).draw();
  } );
})