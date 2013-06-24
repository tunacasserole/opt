//= require      buildit_desktop
//= require_tree ./opt_desktop/logic
//= require_tree ./opt_desktop/model
//= require_tree ./opt_desktop/store
//= require_tree ./opt_desktop/view
//= require_tree ./opt_desktop/controller



Buildit.desktopApplication({
	name:'Opt',

	autoCreateViewport:false,

	launch:function () {

		// LAUNCH INITIAL COMPONENT
		Ext.widget('buildit-Viewport', {
      items:[
      {
        xtype: 'buildit-Canvas',
        flex: 1, 
        id: 'canvas',
        title: 'buildit.io',
        subtitle: 'Enterprise Application',
        items: [
          {
            xtype: 'buildit-SecurityCheckpoint',
            id: 'login'
          }
          
        ]
      }
      ]
    });

		Ext.FocusManager.enable();
	}

});
