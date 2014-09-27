App.Views.Index = Backbone.View.extend({
  el: 'body',

  events: {
    'click': '_close',
    'click #input': '_onClickInput',
    'click #submit': '_onClickButton',
    'click .geo': '_onClickGeo'
  },

  initialize: function() {
    _.bindAll(this, '_fillCurrentPosition');

    this.$title = this.$('.site-title');
    this.$input = this.$('#input');
    this.$lat = this.$('#lat');
    this.$lon = this.$('#lon');

    this._initViews();
  },

  _initViews: function() {
    cartodb.createVis('map', 'http://jacathon-huracan.cartodb.com/api/v2/viz/2e9a4b52-4622-11e4-bdaf-0e9d821ea90d/viz.json');
  },

  _onClickGeo: function(e) {
    e.preventDefault();

    navigator.geolocation.getCurrentPosition(this._fillCurrentPosition);
  },

  _fillCurrentPosition: function(pos) {
    this.$lat.val(pos.coords.latitude);
    this.$lon.val(pos.coords.longitude);

    this.$('.geo').addClass('is-hidden');
    this.$('.geo-on').removeClass('is-hidden');
  },

  _onClickButton: function(e) {
    e.stopPropagation();

debugger;
    if (this.$input.val() == '' && (this.$lat == '' && this.$lon == '')) {
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
