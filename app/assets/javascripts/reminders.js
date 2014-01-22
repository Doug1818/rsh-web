jQuery(document).ready(function($) {

  $('.datepicker').pickadate();
  $('.timepicker').pickatime();

  $(document).on('click','.new-reminder-link',function (event) {
    //console.log( $(this).prev().prev().attr("class") );
    $(this).prev().prev().find(".form").show();
    event.preventDefault(); // Prevent link from following its href
  });

  $(document).on('change', '.frequency', function (event) {
    
    $('.frequency-option').hide();
    $('.message-send-on').hide();

    var frequency = $(this).val();

    if (frequency == 0) {
      $('.once').show();
      $("label[for='reminder_send_on']").text("On");
    }
    else if (frequency == 1) {
      $('.daily').show();
      $("label[for='reminder_send_on']").text("Starting");
    }
    else if (frequency == 2) {
      $('.weekly').show();
      $("label[for='reminder_send_on']").text("Starting");
    }
    else if (frequency == 3) {
      $('.monthly').show();
      $("label[for='reminder_send_on']").text("Starting");
    }
    else {

    }
    $('.message-send-on').show();

    event.preventDefault();
  });

});