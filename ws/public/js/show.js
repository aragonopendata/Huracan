App.Views.Index = Backbone.View.extend({
  el: 'body',

  events: {

  },

  initialize: function() {
    this._initViews();
  },

  _initViews: function() {
    cartodb.createVis('map', 'http://jacathon-huracan.cartodb.com/api/v2/viz/2e9a4b52-4622-11e4-bdaf-0e9d821ea90d/viz.json')
      .done(function(vis, layers) {
        var map = vis.getNativeMap(),
            sql_query = 'SELECT * FROM tracks WHERE fid = '+track_id;

        var sql = new cartodb.SQL({ user: 'jacathon-huracan' });

        sql.getBounds(sql_query).done(function(bounds) {
          map.fitBounds(bounds);
        });

        layers[1].getSubLayer(0).setSQL(sql_query);
      });
  }
});
