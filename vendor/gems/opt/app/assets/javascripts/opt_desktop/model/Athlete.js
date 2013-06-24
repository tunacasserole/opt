Ext.define('Opt.model.Athlete', {
  extend: 'Ext.data.Model',

  fields: [
      { name: 'athlete_id',                  type: 'string'   },
      { name: 'first_name',                  type: 'string'   },
      { name: 'last_name',                   type: 'string'   },
      { name: 'full_name',                   type: 'string'   },
      { name: 'is_destroyed',                type: 'boolean'  }
    ],

  idProperty: 'athlete_id',

  proxy: {
    type: 'direct',
    api: {
      create:  Opt.service.Athlete.create,
      read:    Opt.service.Athlete.read,
      update:  Opt.service.Athlete.update,
      destroy: Opt.service.Athlete.destroy
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