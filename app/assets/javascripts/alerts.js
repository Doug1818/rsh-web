// show the form for adding a new alert
jQuery(document).ready(function($) {
  $(document).on('click','.new-alert-link',function (event) {
    console.log( $(this).next().attr("class") );
    $(this).next().find(".form").show();
    event.preventDefault(); // Prevent link from following its href
  });
});