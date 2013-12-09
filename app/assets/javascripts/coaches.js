jQuery(document).ready(function($) {

  $("#coach_gender, #coach_status").select2({
    minimumResultsForSearch: -1
  });

  $('input[type=checkbox]').uniform();

});
