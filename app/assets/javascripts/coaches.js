jQuery(document).ready(function($) {

  $("#coach_gender").select2({
    minimumResultsForSearch: -1,
    placeholder: 'Gender'
  });

  $("#coach_status").select2({
    minimumResultsForSearch: -1
  });

  $('input[type=checkbox]').uniform();

});
