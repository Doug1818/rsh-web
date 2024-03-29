jQuery(document).ready(function($) {
  // when the frequency pull down is changed, show the appropriate "extra" fields
  $(document).on('change','.small-step-frequency',function() {
    displayFrequencyFields( $(this) );
    $('input[type=checkbox]').uniform();
  });

  // hide the small-step, display the form
  $(document).on('click','.small-step-edit-link',function (event) {
    $(this).parent().parent().hide();
    $(this).parent().parent().parent().find(".form").show();
    event.preventDefault(); // Prevent link from following its href
  });


  // hide the form, display the small step
  $(document).on('click','.small-step-cancel-button',function (event) {
    $(this).parent().parent().parent().parent().find(".display").show();
    $(this).parent().parent().parent().parent().find(".form").hide();
    event.preventDefault(); // Prevent link from following its href
  });

  // show the form for adding a new small-step to the current week
  $(document).on('click','.new-small-step-link',function (event) {
    console.log( $(this).next().attr("class") );
    $(this).next().find(".form").show();
    event.preventDefault(); // Prevent link from following its href
  });

  $('input[type=checkbox]').uniform();

});

// this gets called from the on("change", ".small-step-frequency") above,
// as well as on the _small_step partial (to pre-fill existing form elements that are being edited)
function displayFrequencyFields(o) {
  if (o.val() == 0) {
    o.parent().find(".specific-days-per-week").hide();
    o.parent().find(".times-per-week").hide();
  } else if (o.val() == 1) {
    o.parent().find(".specific-days-per-week").hide();
    o.parent().find(".times-per-week").show();
  } else if (o.val() == 2) {
    o.parent().find(".specific-days-per-week").show();
    o.parent().find(".times-per-week").hide();
  }
}


