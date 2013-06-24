Ext.define('Opt.model.AthleteWorkout', {
  extend: 'Ext.data.Model',

  fields: [
      { name: 'workout_id',                  type: 'string'   },
      { name: 'athlete_id',                  type: 'string'   },
      { name: 'workout_name',                type: 'string'   },
      { name: 'state',                       type: 'string'   },
      { name: 'workout_date',                type: 'date'     },
      { name: 'description',                 type: 'string'   },
      { name: 'results',                     type: 'string'   },
      { name: 'is_destroyed',                type: 'boolean'  }
    ],

  idProperty: 'athlete_workout_id',

  proxy: {
    type: 'direct',
    api: {
      create:  Opt.service.AthleteWorkout.create,
      read:    Opt.service.AthleteWorkout.read,
      update:  Opt.service.AthleteWorkout.update,
      destroy: Opt.service.AthleteWorkout.destroy
    },
    reader: {
      type : 'json',
      root : 'records',
      totalProperty  : 'total',
      successProperty: 'success'
    }
  },


  validations: [

  ]

});