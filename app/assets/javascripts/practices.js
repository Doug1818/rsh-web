// Stripe
var subscription;

jQuery(function($) {
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
  subscription.setupForm();
});

subscription = {
  setupForm: function() {
    $('#edit_practice').submit(function() {
      $('input[type=submit]').attr('disabled', true);
      subscription.processCard();
      return false;
    });
  },
  processCard: function() {
    var card;
    card = {
      number: $('#card_number').val(),
      cvc: $('#card_code').val(),
      expMonth: $('#card_month').val(),
      expYear: $('#card_year').val()
    };
    Stripe.createToken(card, subscription.handleStripeResponse);
  },
  handleStripeResponse: function(status, response) {
    if (status == 200) {
      $('#stripe_card_token').val(response.id);
      $('#edit_practice')[0].submit();
    } else {
      $('.payment-errors').text(response.error.message);
      $('input[type=submit]').attr('disabled', false);
    }
  }
};

// jQuery(function($) {
//   $('#edit_practice').submit(function(event) {
//     var $form = $(this);
//     // Disable the submit button to prevent repeated clicks
//     $form.find('button').prop('disabled', true);
//     alert("Yo!");
//     // Stripe.createToken($form, stripeResponseHandler);
//     Stripe.createToken({
//         number: $('.card-number').val(),
//         cvc: $('.card-cvc').val(),
//         exp_month: $('.card-expiry-month').val(),
//         exp_year: $('.card-expiry-year').val()
//     }, stripeResponseHandler);
//     // alert(response.id);
//     // alert("Yo! 1");
//     // Prevent the form from submitting with the default action
//     return false;
//   });
// });

// var stripeResponseHandler = function(status, response) {
//   var $form = $('#edit_practice');
//   alert("stripeResponseHandler");
//   if (response.error) {
//     // scroll up
//     window.scrollTo(0, 0);

//     // Show the errors on the form
//     $('.payment-errors').show();
//     $('.payment-errors').text(response.error.message);
//     $form.find('button').prop('disabled', false);
//   } else {
//     // token contains id, last4, and card type
//     var token = response.id;
//     // Insert the token into the form so it gets submitted to the server
//     // $('#stripe_card_token').val(token);
//     $form.append($('<input type="hidden" name="stripeToken" />').val(token));
//     // and submit
//     $form.get(0).submit();
//   }
// };
