jQuery(document).ready(function($) {

  $('.datepicker').pickadate();

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

  $('.past_week .small-steps-for-week').on('click', function(){
    $(this).find('.collapse').collapse();
  });

  $("html, body").find('#steps').animate({ scrollTop: $('.current_week').offset().top - 370 }, 1000);
});
