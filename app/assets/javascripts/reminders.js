jQuery(document).ready(function($) {

  $('.datepicker').pickadate();
  $('.timepicker').pickatime();

  $(document).on('click','.new-reminder-link',function (event) {
    console.log( $(this).next().attr("class") );
    $(this).next().find(".form").show();
    event.preventDefault(); // Prevent link from following its href
  });

  $(document).on('change', '.frequency', function (event) {
    
    $('.frequency-option').hide();

    var frequency = $(this).val();

    if (frequency == 0) {
      $('.once').show();
    }
    else if (frequency == 2) {
      $('.weekly').show();
    }
    else {

    }
    event.preventDefault();
  });

});