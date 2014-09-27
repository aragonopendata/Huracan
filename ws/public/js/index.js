App.Views.Index = Backbone.View.extend({
  el: 'body',

  events: {
    'click': '_close',
    'click #input': '_onClickInput',
    'click #submit': '_onClickButton'
  },

  initialize: function() {
    this.$title = this.$('.site-title');
    this.$input = this.$('#input');

    this._initViews();
  },

  _initViews: function() {
    cartodb.createVis('map', 'http://jacathon-huracan.cartodb.com/api/v2/viz/2e9a4b52-4622-11e4-bdaf-0e9d821ea90d/viz.json');
  },

  _onClickButton: function(e) {
    e.stopPropagation();

    if (this.$input.val() == '') {
      e.preventDefault();

      this._toggle();
    }
  },

  _onClickInput: function(e) {
    e.stopPropagation();
  },

  _close: function() {
    this.$input.val('');

    if (!this.$input.hasClass('is-hidden')) {
      this.$input.addClass('is-hidden');
    }

    if (this.$title.hasClass('is-hidden')) {
      this.$title.removeClass('is-hidden');
    }
  },

  _toggle: function() {
    this.$title.toggleClass('is-hidden');
    this.$input.toggleClass('is-hidden');

    if (this.$input.is(':visible')) {
      this.$input.focus();
    }
  }
});
