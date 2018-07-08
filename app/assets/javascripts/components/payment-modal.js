(function() {
  App.paymentModal = {
    pollingPaymentStateTimer: null,

    startPollingPaymentState: function() {
      var that = this;

      if (that.pollingPaymentStateTimer) {
        clearTimeout(that.pollingPaymentStateTimer);
        that.pollingPaymentStateTimer = null;
      }

      var trace = that.modal().data('payment-trace');
      var post_id = that.modal().data('post-id');

      var path = '/payment_state?trace=' + trace;
      var post_path = '/posts/' + post_id;
      var fn = function() {
        $.get(path, function(data) {
          if (data === 'paid') {
            Turbolinks.visit(post_path);
            that.pollingPaymentStateTimer = null;
          } else {
            that.pollingPaymentStateTimer = setTimeout(fn, 1000);
          }
        }).fail(function() {
          that.pollingPaymentStateTimer = setTimeout(fn, 1000);
        });
      };

      fn();
    },

    modal: function() {
      return $('.new-post-payment-modal');
    }
  };
}).call(this);
