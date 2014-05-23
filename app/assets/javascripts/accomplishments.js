jQuery(document).ready(function($) {

  $('.accomp_datepicker').pickadate({
    format: 'mmmm dd, yyyy',
    onStart: function() {
      var date = new Date()
      this.set('select', [date.getFullYear(), date.getMonth(), date.getDate()]);
    }
  });

  // show the form for adding a new accomplishment
	jQuery(document).ready(function($) {
	  $(document).on('click','.new-accomplishment-link',function (event) {
	    //console.log( $(this).prev().prev().attr("class") );
	    $(this).prev().prev().find(".form").show();
	    event.preventDefault(); // Prevent link from following its href
	  });
	});
});
