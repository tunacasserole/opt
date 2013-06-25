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
        {title: 'Profile',           xtype: 'opt-athletes-Form'},
        {title: 'Workouts', xtype: 'opt-athlete_workouts-Explorer',
           defaultSearch: { with: 
             {
               athlete_id:   {equal_to: me.record.get('athlete_id')}
             }
          }
        },                                    
        {
          title: 'Notes',
          xtype: 'buildit-notes-Explorer',
          module: 'notes',                      
          defaultSearch: { with: 
            {
              notable_type: {equal_to: 'Sbna::Cfar'},
              notable_id:   {equal_to: me.record.get('cfar_id')}
            }
          }
        },
        {
          title: 'Attachments',
          xtype: 'buildit-attachments-Explorer',
          module: 'attachments',                      
          defaultSearch: { with: 
            {
              attachable_type: {equal_to: 'Sbna::Cfar'},
              attachable_id:   {equal_to: me.record.get('cfar_id')}
            }
          }
        }        
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