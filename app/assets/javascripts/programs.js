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

  $(function(){
    $('.small-steps-for-week').each(function(i) {
      if(i > -1){
        $(this).addClass("week-number-" + (i+1));
      }
    });
  });
  
  $('.collapse').on('hidden.bs.collapse', function(){
    $('#steps').animate({ scrollTop: $('.past_week').offset().top - 370 }, 1000);
  });


  $("html, body").find('#steps').animate({ scrollTop: $('.current_week').offset().top - 370 }, 1000);
});
