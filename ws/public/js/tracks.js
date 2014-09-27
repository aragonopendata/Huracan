App.Views.Index = Backbone.View.extend({
  el: 'body',

  initialize: function() {
    this._initViews();
  },

  _initViews: function() {
    cartodb.createVis('map', 'http://jacathon-huracan.cartodb.com/api/v2/viz/2e9a4b52-4622-11e4-bdaf-0e9d821ea90d/viz.json')
      .done(function(vis, layers) {
        var tracks_id_ = tracks_id.shift();

        _.each(tracks_id, function(val, index) {
          tracks_id_ += ' OR fid = '+val
        });

        var map = vis.getNativeMap(),
            sql_query = 'SELECT * FROM tracks WHERE fid = '+tracks_id_;

        var sql = new cartodb.SQL({ user: 'jacathon-huracan' });

        sql.getBounds(sql_query).done(function(bounds) {
          map.fitBounds(bounds);
        });

        layers[1].getSubLayer(0).setSQL(sql_query);
      });
  }
});
