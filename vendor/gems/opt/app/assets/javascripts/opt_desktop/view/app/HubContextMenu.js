Ext.define('Opt.view.app.HubContextMenu', {
  extend: 'Buildit.ux.ContextMenu',
  alias:  'widget.opt-app-HubContextMenu',

  
  initComponent: function() {
    var me = this;

    Ext.apply(this, {

      rightActions: [

        /**
         * DELETE
         * Supports the deletion of the selected items in the explorer grid. If none
         * are selected then no records are deleted.
         */
        {
          text:'Settings',
          cls: 'icon-settings',
          action: 'settings',
          confirm: true,
          multi: true,
          privileges: [],
          listeners: {
            click: {
              fn: Ext.emptyFn,
              scope: me
            }
          }
        },

        // SEPARATOR
        '-',


        /**
         * DELETE
         * Supports the deletion of the selected items in the explorer grid. If none
         * are selected then no records are deleted.
         */
        {
          text:'Applications',
          cls: 'icon-applications',
          action: 'applications',
          confirm: true,
          multi: true,
          privileges: [],
          listeners: {
            click: {
              fn: Ext.emptyFn,
              scope: me
            }
          }
        }

      ],


      leftActions: [

        /**
         * NEW
         * Supports the deletion of the selected items in the explorer grid. If none
         * are selected then no records are deleted.
         
        {
          text: 'New',
          cls: 'icon-new'
        }
        */
      ]

    });

    this.callParent();
  }

});