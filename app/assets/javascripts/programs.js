jQuery(document).ready(function($) {

  $('.datepicker').pickadate({
    format: 'mmmm dd, yyyy',
    onStart: function() {
      var date = new Date()
      this.set('select', [date.getFullYear(), date.getMonth(), date.getDate() + 1]);
    }
  });

  if($('form').hasClass('new-program')){
    $('select').select2({
      minimumResultsForSearch: -1,
      width: 267,
      placeholder: 'Gender'
    });
  } else {
    $('select').select2({
      minimumResultsForSearch: -1,
      width: 200
    });
  }



  $(document).on('cocoon:after-insert','#program_small_steps',function (event) {
    $('select').select2({
      minimumResultsForSearch: -1,
      width: 200
    });
  });

  $('button.toggle').on('click', function(){
    var _this = $(this);
    _this.html(_this.text() == 'hide' ? 'show' : 'hide');
  });

  $('.display').hover(
    function() {
      $(this).find('.links').css('display', 'inline-block');
    }, function() {
      $(this).find('.links').css('display', 'none');
    }
  );

  $('.collapse').on('hidden.bs.collapse', function(){
    // JOSH, the .top proerty is throwing an error in the console, which is breaking other js stuff
    $('#steps').animate({ scrollTop: $('.past_week').offset().top - 370 }, 1000);
  });


  // JOSH, the .top proerty is throwing an error in the console, which is breaking other js stuff
 $("html, body").find('#steps').animate({ scrollTop: $('.col-md-1').offset().top }, 1000);
});
