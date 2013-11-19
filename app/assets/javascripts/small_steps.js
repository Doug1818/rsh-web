$(document).ready(function() {
  $(document).on("change",".small-step-frequency",function() {
    if ($(this).val() == 0) {
      $(this).parent().find(".specifc-days-per-week").hide();
      $(this).parent().find(".times-per-week").hide();
    } else if ($(this).val() == 1) {
      $(this).parent().find(".specifc-days-per-week").hide();
      $(this).parent().find(".times-per-week").show();
    } else if ($(this).val() == 2) {
      $(this).parent().find(".specifc-days-per-week").show();
      $(this).parent().find(".times-per-week").hide();
    }
  });
});



