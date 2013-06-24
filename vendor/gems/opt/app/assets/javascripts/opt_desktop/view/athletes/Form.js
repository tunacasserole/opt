Ext.define('Opt.view.athletes.Form', {

  extend:'Buildit.ux.Form',
  alias:'widget.opt-athletes-Form',


  initComponent:function () {

    var me = this;

    // FILTER (Start) =======================================================================
    var associativeFilter = {
      property:   'athlete_id',
      value:      this.record.get('athlete_id')
    };
    // FILTER (End)

    
    // LABELS (Start) =======================================================================
    Ext.applyIf(this, {
      athlete_idLabel:                        Opt.i18n.model.Athlete.athlete_id,    
      first_nameLabel:                        Opt.i18n.model.Athlete.first_name,    
      last_nameLabel:                         Opt.i18n.model.Athlete.last_name,    
      full_nameLabel:                         Opt.i18n.model.Athlete.full_name,    
      is_destroyedLabel:                      Opt.i18n.model.Athlete.is_destroyed    
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

            // { xtype: 'textfield', name: 'athlete_id',                     fieldLabel: this.athlete_idLabel                  , allowBlank: false },    
            { xtype: 'textfield', name: 'first_name',                     fieldLabel: this.first_nameLabel                  , allowBlank: false },    
            { xtype: 'textfield', name: 'last_name',                      fieldLabel: this.last_nameLabel                   , allowBlank: false },    
            // { xtype: 'textfield', name: 'full_name',                      fieldLabel: this.full_nameLabel                   , allowBlank: false },    
            // { xtype: 'textfield', name: 'is_destroyed',                   fieldLabel: this.is_destroyedLabel                , allowBlank: false }    
          ]
        }
      ]
    });
    // FIELDSETS (End)


    // TITLES (Start) ======================================================================
    Ext.applyIf(this, {
      title: 'Profile',
      subtitle: 'Edit Athletes',
      newTitle: 'New Athlete',
      newSubtitle: 'Complete the following to create a new Athlete'
    });
    // TITLES (End)

    this.callParent();
    
  }

});