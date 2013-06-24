Ext.define('Opt.view.athlete_workouts.Inspector',{
  extend: 'Buildit.ux.inspector.Panel',
  alias: 'widget.opt-athlete_workouts-Inspector',


  initComponent:function(){
    var me = this;
  
    // INSPECTOR INIT (Start) ==============================================================
    Ext.applyIf(this, {
      associativeFilter: {
        property:   'athlete_workout_id',
        value:      this.record.get('athlete_workout_id')
      }
    });
    // INSPECTOR INIT (End)
  
    // CARDS (Start) =======================================================================
    Ext.apply(this, {
      cards: [
        {title: 'Profile',           xtype: 'opt-athlete_workouts-Form'}
      ]
    });
    // CARDS (End)

    // TITLES (Start) ======================================================================
    Ext.applyIf(this, {
      title:     'Athlete Workout',
      subtitle:  this.record.get('athlete_workout_id')
    });
    // TITLES (End)

    this.callParent();
  }
});