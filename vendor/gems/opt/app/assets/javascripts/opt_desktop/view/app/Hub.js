Ext.define('Opt.view.app.Hub', {
	extend: 'Buildit.ux.Hub',
	alias: 'widget.opt-app-Hub',

	bodyStyle: 'background: transparent',

  cls: 'desktop',

	initComponent: function(){
		var me = this;

		Ext.apply(this, {
		  allowSignout      : true,
      title             : 'Start',
      subtitle          : 'OPT Standard Desktop',
      contextMenuConfig : {
        xtype: 'opt-app-HubContextMenu'
      },
      sections          : [
        {
          title    : 'General',
          columns  : 6,
          rows     : 3,
          tiles    : [
            {colspan: 2, rowspan: 1, title: 'Athletes', cls: 'contacts', target: { xtype: 'opt-athletes-Explorer'} },
          ]
        }
        ,{
          title    : 'Activity',
          columns  : 4,
          rows     : 3,
          tiles    : [
            {
              xtype            : 'buildit-events-LiveTile',
              colspan          : 4,
              rowspan          : 3,
              height           : 380,
              target           : {
                xtype            : 'opt-athletes-Explorer'
              }
            },
          ]
        }
      ]
    });

    this.callParent();
  }
});