App.Views.Index = Backbone.View.extend({
  el: 'body',

  events: {
    'click': '_close',
    'click .nav input': '_onClickInput',
    'click .nav button': '_onClickButton'
  },

  initialize: function() {
    this.$title = this.$('.site-title');
    this.$input = this.$('.nav input');

    this._initViews();
  },

  _initViews: function() {
    cartodb.createVis('map', 'http://jacathon-huracan.cartodb.com/api/v2/viz/bb762f76-45ca-11e4-b06d-0e9d821ea90d/viz.json');
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
