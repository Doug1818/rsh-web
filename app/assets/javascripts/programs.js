jQuery(document).ready(function($) {

  $('.datepicker').pickadate();

  $('select').select2({
    minimumResultsForSearch: -1,
    width: 200
  });

  $(document).on('cocoon:after-insert','#program_small_steps',function (event) {
    $('select').select2({
      minimumResultsForSearch: -1,
      width: 200
    });
  });

});
