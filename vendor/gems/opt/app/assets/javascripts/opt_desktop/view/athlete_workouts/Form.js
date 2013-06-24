Ext.define('Opt.view.athlete_workouts.Form', {

  extend:'Buildit.ux.Form',
  alias:'widget.opt-athlete_workouts-Form',


  initComponent:function () {

    var me = this;

    // FILTER (Start) =======================================================================
    var associativeFilter = {
      property:   'athlete_workout_id',
      value:      this.record.get('athlete_workout_id')
    };
    // FILTER (End)

    
    // LABELS (Start) =======================================================================
    Ext.applyIf(this, {
      workout_idLabel:                        Opt.i18n.model.AthleteWorkout.workout_id,    
      athlete_idLabel:                        Opt.i18n.model.AthleteWorkout.athlete_id,    
      workout_nameLabel:                      Opt.i18n.model.AthleteWorkout.workout_name,    
      stateLabel:                             Opt.i18n.model.AthleteWorkout.state,    
      workout_dateLabel:                      Opt.i18n.model.AthleteWorkout.workout_date,    
      descriptionLabel:                       Opt.i18n.model.AthleteWorkout.description,    
      resultsLabel:                           Opt.i18n.model.AthleteWorkout.results,    
      is_destroyedLabel:                      Opt.i18n.model.AthleteWorkout.is_destroyed    
    });
    // LABELS (End)

    // FIELDSETS (Start) ====================================================================
    Ext.apply(this, {
      items: [
        {
          xtype:        'fieldset',
          title:        'General Information',
          collapsible:  true,
          defaultType:  'textfield',
          defaults:     {anchor: '95%'},
          layout:       'anchor',
          items:[
          /*
            {
              xtype: 'buildit-Locator', 
              store: Ext.create('MyApp.store.MyModel',{pageSize: 10}), 
              displayField: 'name', 
              queryField: 'name', 
              valueField: 'value_field', 
              itemTpl:'{name}',
              name: 'attribute_name', 
              fieldLabel: this.attribute_nameLabel, 
              allowBlank: true 
            }
          */

            { xtype: 'textfield', name: 'workout_id',                     fieldLabel: this.workout_idLabel                  , allowBlank: false },    
            { xtype: 'textfield', name: 'athlete_id',                     fieldLabel: this.athlete_idLabel                  , allowBlank: false },    
            { xtype: 'textfield', name: 'workout_name',                   fieldLabel: this.workout_nameLabel                , allowBlank: false },    
            { xtype: 'textfield', name: 'state',                          fieldLabel: this.stateLabel                       , allowBlank: false },    
            { xtype: 'textfield', name: 'workout_date',                   fieldLabel: this.workout_dateLabel                , allowBlank: false },    
            { xtype: 'textfield', name: 'description',                    fieldLabel: this.descriptionLabel                 , allowBlank: false },    
            { xtype: 'textfield', name: 'results',                        fieldLabel: this.resultsLabel                     , allowBlank: false },    
            { xtype: 'textfield', name: 'is_destroyed',                   fieldLabel: this.is_destroyedLabel                , allowBlank: false }    
          ]
        }
      ]
    });
    // FIELDSETS (End)


    // TITLES (Start) ======================================================================
    Ext.applyIf(this, {
      title: 'Profile',
      subtitle: 'Edit AthleteWorkouts',
      newTitle: 'New Athlete Workout',
      newSubtitle: 'Complete the following to create a new Athlete Workout'
    });
    // TITLES (End)

    this.callParent();
    
  }

});