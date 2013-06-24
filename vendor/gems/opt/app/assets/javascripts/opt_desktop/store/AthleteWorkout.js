Ext.define('Opt.store.AthleteWorkout', {
  extend       : 'Ext.data.Store',
  alias        : 'store.opt-AthleteWorkout',
  model        : 'Opt.model.AthleteWorkout',
  autoLoad     : false,
  storeId      : 'AthleteWorkoutStore',
  remoteFilter : true,
  remoteSort   : true,

  constructor  : function (config) {
    var me = this;
    me.callParent(this);
    var proxy = Ext.Object.merge({}, me.getProxy());
    me.setProxy(proxy);
  } // constructor

}); // Ext.define