Ext.define('Opt.view.athletes.Explorer', {

  extend:'Buildit.ux.explorer.Panel',
  alias:'widget.opt-athletes-Explorer',

  // EXPLORER INIT (Start) ===============================================================
  allowFind: false,

  store: Ext.create('Opt.store.Athlete'),

  contextMenuConfig: {
    xtype: 'opt-athletes-ExplorerContextMenu'
  },

  newForms:[{
    xtype: 'opt-athletes-Form'
  }],

  inspectorConfig: {
    xtype: 'opt-athletes-Inspector'
  },
  // EXPLORER INIT (End)

  // LABELS (Start) ======================================================================
  athlete_idLabel:                        Opt.i18n.model.Athlete.athlete_id,
  first_nameLabel:                        Opt.i18n.model.Athlete.first_name,
  last_nameLabel:                         Opt.i18n.model.Athlete.last_name,
  full_nameLabel:                         Opt.i18n.model.Athlete.full_name,
  is_destroyedLabel:                      Opt.i18n.model.Athlete.is_destroyed,
  // LABELS (End)
  
  // TITLES (Start) ======================================================================
  title:     'Athletes',
  subtitle:  'Create and maintain Athletes',
  // TITLES (End)

  initComponent:function () {

    var me = this;

    // COLUMNS (Start) =====================================================================
    Ext.apply(this, {
      columns: [
        // { header: this.athlete_idLabel,                    dataIndex: 'athlete_id',                  flex: 1 },    
        { header: this.first_nameLabel,                    dataIndex: 'first_name',                  flex: 1 },    
        { header: this.last_nameLabel,                     dataIndex: 'last_name',                   flex: 1 },    
        // { header: this.full_nameLabel,                     dataIndex: 'full_name',                   flex: 1 },    
        // { header: this.is_destroyedLabel,                  dataIndex: 'is_destroyed',                flex: 1 }    
      ]
    });
    // COLUMNS (End)


    this.callParent();
  }

});