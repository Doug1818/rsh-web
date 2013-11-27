jQuery(document).ready(function($) {

  $('.datepicker').pickadate();

  $('select').select2({
    minimumResultsForSearch: -1,
    width: 200
  });

});
