App.Views.Index = Backbone.View.extend({
  el: 'body',

  events: {

  },

  initialize: function() {
    this._initViews();
  },

  _initViews: function() {
    cartodb.createVis('map', 'http://jacathon-huracan.cartodb.com/api/v2/viz/bb762f76-45ca-11e4-b06d-0e9d821ea90d/viz.json')
      .done(function(vis, layers) {
        layers[1].getSubLayer(0).setSQL("SELECT * FROM tracks WHERE cartodb_id = 315");
      });
  }
});
