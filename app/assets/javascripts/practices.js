jQuery(function($) {
  $('#new_practice').submit(function(event) {
    var $form = $(this);

    // Disable the submit button to prevent repeated clicks
    $form.find('button').prop('disabled', true);

    // Stripe.createToken($form, stripeResponseHandler);
    Stripe.createToken({
        number: $('.card-number').val(),
        cvc: $('.card-cvc').val(),
        exp_month: $('.card-expiry-month').val(),
        exp_year: $('.card-expiry-year').val()
    }, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
  });
});

var stripeResponseHandler = function(status, response) {
  var $form = $('#new_practice');

  if (response.error) {
    // scroll up
    window.scrollTo(0, 0);

    // Show the errors on the form
    $('.payment-errors').show();
    $('.payment-errors').text(response.error.message);
    $form.find('button').prop('disabled', false);
  } else {
    // token contains id, last4, and card type
    var token = response.id;
    // Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    // and submit
    $form.get(0).submit();
  }
};
