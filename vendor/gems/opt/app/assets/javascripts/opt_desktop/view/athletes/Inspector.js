Ext.define('Opt.view.athletes.Inspector',{
  extend: 'Buildit.ux.inspector.Panel',
  alias: 'widget.opt-athletes-Inspector',


  initComponent:function(){
    var me = this;
  
    // INSPECTOR INIT (Start) ==============================================================
    Ext.applyIf(this, {
      associativeFilter: {
        property:   'athlete_id',
        value:      this.record.get('athlete_id')
      }
    });
    // INSPECTOR INIT (End)
  
    // CARDS (Start) =======================================================================
    Ext.apply(this, {
      cards: [
        {title: 'Profile',           xtype: 'opt-athletes-Form'}
      ]
    });
    // CARDS (End)

    // TITLES (Start) ======================================================================
    Ext.applyIf(this, {
      title:     'Athlete',
      subtitle:  this.record.get('full_name')
    });
    // TITLES (End)

    this.callParent();
  }
});