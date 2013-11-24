$(document).ready(function() {
  $(document).on("change",".small-step-frequency",function() {
    displayFrequencyFields( $(this) );
  });
});

function displayFrequencyFields(o) {
  if (o.val() == 0) {
    o.parent().find(".specifc-days-per-week").hide();
    o.parent().find(".times-per-week").hide();
  } else if (o.val() == 1) {
    o.parent().find(".specifc-days-per-week").hide();
    o.parent().find(".times-per-week").show();
  } else if (o.val() == 2) {
    o.parent().find(".specifc-days-per-week").show();
    o.parent().find(".times-per-week").hide();
  }
}
