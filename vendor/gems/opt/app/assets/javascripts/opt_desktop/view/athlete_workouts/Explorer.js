Ext.define('Opt.view.athlete_workouts.Explorer', {

  extend:'Buildit.ux.explorer.Panel',
  alias:'widget.opt-athlete_workouts-Explorer',

  // EXPLORER INIT (Start) ===============================================================
  allowFind: false,

  store: Ext.create('Opt.store.AthleteWorkout'),

  contextMenuConfig: {
    xtype: 'opt-athlete_workouts-ExplorerContextMenu'
  },

  newForms:[{
    xtype: 'opt-athlete_workouts-Form'
  }],

  inspectorConfig: {
    xtype: 'opt-athlete_workouts-Inspector'
  },
  // EXPLORER INIT (End)

  // LABELS (Start) ======================================================================
  workout_idLabel:                        Opt.i18n.model.AthleteWorkout.workout_id,
  athlete_idLabel:                        Opt.i18n.model.AthleteWorkout.athlete_id,
  workout_nameLabel:                      Opt.i18n.model.AthleteWorkout.workout_name,
  stateLabel:                             Opt.i18n.model.AthleteWorkout.state,
  workout_dateLabel:                      Opt.i18n.model.AthleteWorkout.workout_date,
  descriptionLabel:                       Opt.i18n.model.AthleteWorkout.description,
  resultsLabel:                           Opt.i18n.model.AthleteWorkout.results,
  is_destroyedLabel:                      Opt.i18n.model.AthleteWorkout.is_destroyed,
  // LABELS (End)
  
  // TITLES (Start) ======================================================================
  title:     'AthleteWorkouts',
  subtitle:  'Create and maintain AthleteWorkouts',
  // TITLES (End)

  initComponent:function () {

    var me = this;

    // COLUMNS (Start) =====================================================================
    Ext.apply(this, {
      columns: [
        { header: this.workout_idLabel,                    dataIndex: 'workout_id',                  flex: 1 },    
        { header: this.athlete_idLabel,                    dataIndex: 'athlete_id',                  flex: 1 },    
        { header: this.workout_nameLabel,                  dataIndex: 'workout_name',                flex: 1 },    
        { header: this.stateLabel,                         dataIndex: 'state',                       flex: 1 },    
        { header: this.workout_dateLabel,                  dataIndex: 'workout_date',                flex: 1 },    
        { header: this.descriptionLabel,                   dataIndex: 'description',                 flex: 1 },    
        { header: this.resultsLabel,                       dataIndex: 'results',                     flex: 1 },    
        { header: this.is_destroyedLabel,                  dataIndex: 'is_destroyed',                flex: 1 }    
      ]
    });
    // COLUMNS (End)


    this.callParent();
  }

});