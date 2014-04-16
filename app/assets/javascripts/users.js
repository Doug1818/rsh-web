jQuery(document).ready(function($) {
  $(document).on('change', '#program_user_attributes_hipaa_compliant', function (event) {

    if ($(this).is(':checked')) {
      $("#pii-fields-non-hipaa").hide();
      $("#pii-fields-hipaa").show();
    } else {
      $("#pii-fields-hipaa").hide();
      $("#pii-fields-non-hipaa").show();
    }
  });
});
