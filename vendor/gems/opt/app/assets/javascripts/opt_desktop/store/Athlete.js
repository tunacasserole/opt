Ext.define('Opt.store.Athlete', {
  extend       : 'Ext.data.Store',
  alias        : 'store.opt-Athlete',
  model        : 'Opt.model.Athlete',
  autoLoad     : false,
  storeId      : 'AthleteStore',
  remoteFilter : true,
  remoteSort   : true,

  constructor  : function (config) {
    var me = this;
    me.callParent(this);
    var proxy = Ext.Object.merge({}, me.getProxy());
    me.setProxy(proxy);
  } // constructor

}); // Ext.define