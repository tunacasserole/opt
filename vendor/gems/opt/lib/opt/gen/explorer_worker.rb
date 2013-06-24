#
#                   Copyright (c) 2012 BUILDIT.IO, Inc.
#                          ALL RIGHTS RESERVED
#
#  THIS PROGRAM CONTAINS PROPRIETARY INFORMATION OF BUILDIT.IO, INC.
#  --------------------------------------------------------------------
#
#  THIS PROGRAM CONTAINS THE CONFIDENTIAL AND/OR PROPRIETARY INFORMATION
#  OF BUILDIT.IO, INC. ANY DUPLICATION, MODIFICATION, DISTRIBUTION, PUBLIC
#  PERFORMANCE, OR PUBLIC DISPLAY OF THIS PROGRAM, OR ANY PORTION OR
#  DERIVATION THEREOF WITHOUT THE EXPRESS WRITTEN CONSENT OF
#  BUILDIT.IO, INC. IS STRICTLY PROHIBITED.  USE OR DISCLOSURE OF THIS
#  PROGRAM DOES NOT CONVEY ANY RIGHTS TO REPRODUCE, DISCLOSE OR DISTRIBUTE
#  ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT CONTAINS IN
#  WHOLE OR IN PART ANY ASPECT OF THIS PROGRAM.
#

class Opt::Gen::ExplorerWorker < Buildit::Gen::Scaffold::Worker

  PRE_START_TAG   = '// EXPLORER PRE-INIT (Start) ============================================================='
  PRE_END_TAG     = '// EXPLORER PRE-INIT (End)'
  
  POST_START_TAG  = '// EXPLORER POST-INIT (Start) ============================================================'
  POST_END_TAG    = '// EXPLORER POST-INIT (End)'

  CONF_START_TAG  = '// EXPLORER CONFIG (Start) ==============================================================='
  CONF_END_TAG    = '// EXPLORER CONFIG (End)'

  def self.destroy(model, modes=[])
    if modes.include? 'desktop'
      model.explorer_meta.each do |explorer|
        file_name = self.explorer_file_name(model, explorer)
        File.delete(file_name) if File.exists?(file_name)
      end
    end
  end # def self.destroy
  
  # this method is responsible for preparing each of the configured explorer files for the supplied model. The approach is to 
  # iterate over each related explorer component metadata and build a corresponding templated explorer view. It is the role of the
  # processing method to populate each file with the desired contents.
  def self.prepare(model, modes=[])
    initiate 'Preparing the UI desktop explorer'

    if modes.include? 'desktop'
      model.explorer_meta.each do |explorer|
        
        # explorer
        file_name = self.explorer_file_name(model, explorer)
        unless File.exists? file_name
          content = ::ERB.new(self.template).result(binding)
          File.open(file_name, 'w') {|file| file.puts content}
        end

        # context menu
        ecm_file_name = self.explorer_context_menu_file_name(model, explorer)
        unless File.exists? ecm_file_name
          content = ::ERB.new(self.context_menu_template).result(binding)
          File.open(ecm_file_name, 'w') {|file| file.puts content}
        end

          # context menu for STATES ********************************************
          machine = Studio::MachineMeta.where(:model_meta_id => model.model_meta_id).first
          if machine
              machine.event_meta.each do |event|
                  #puts 'processing event ' + event.event_name
                  ecm_file_name = self.explorer_context_menu_file_name(model, explorer).chop.chop.chop + event.event_name.titleize + '.js'
                  unless File.exists? ecm_file_name
                      content = ::ERB.new(self.context_menu_state_template).result(binding)
                      content = Buildit::Util::String.replace(content, event.event_name.titleize, 'Event')
                      content = Buildit::Util::String.replace(content, event.event_name.downcase, 'event')
                      File.open(ecm_file_name, 'w') {|file| file.puts content}
                  end
                  
                  # logic for process selected items ************************************
                  logic_file_name = self.explorer_process_selected_items_file_name(model, explorer)
                  unless File.exists? logic_file_name
                      content = ::ERB.new(self.process_selected_items_template).result(binding)
                      #content = Buildit::Util::String.replace(content, event.event_name.titleize, 'Event')
                      File.open(logic_file_name, 'w') {|file| file.puts content}
                  end
              end
          end
          # end context menu for STATES **********************************************
          
      end
    end
    complete
  end # def self.prepare


  def self.process(model, modes=[])
    initiate 'Creating the UI desktop explorer'

    if modes.include? 'desktop'
      model.explorer_meta.each do |explorer|
        file_name = self.explorer_file_name(model, explorer)
        contents = Buildit::Util::File.read_contents(file_name)
        
        Buildit::Framework.configuration.scaffolders.buildit_client.each do |worker|
          contents = worker.send(:process_explorer, model, explorer, contents) || contents if worker.respond_to? :process_explorer
        end      
        File.open(file_name, 'w') { |file| file.puts contents}
      end
    end
    complete
  end

  # the following prepares the key items managed by this worker in the explorer.
  def self.prepare_explorer_pre_init(model, explorer)
<<-PREP

    #{PRE_START_TAG}
  
    #{PRE_END_TAG}
PREP
  end # def self.prepare_explorer_pre_init

  def self.prepare_explorer_post_init(model, explorer)
<<-PREP

    #{POST_START_TAG}

    #{POST_END_TAG}
PREP
  end # def self.prepare_explorer_post_init


  def self.prepare_explorer_config(model, explorer)
<<-PREP

    #{CONF_START_TAG}

    #{CONF_END_TAG}
PREP
end # def self.prepare_explorer_init
  
  
  
  def self.process_explorer(model, explorer, contents)
    token = /(#{Regexp.escape(PRE_START_TAG)})(.*)(#{Regexp.escape(PRE_END_TAG)})/im
    contents = Buildit::Util::String.replace(contents, self.explorer_pre_contents(model, explorer), token)
    
    token = /(#{Regexp.escape(CONF_START_TAG)})(.*)(#{Regexp.escape(CONF_END_TAG)})/im
    contents = Buildit::Util::String.replace(contents, self.explorer_config_contents(model, explorer), token)
  end
  
  private
  
  def self.explorer_file_name(model, explorer)
    File.join(Rails.root.to_s, 'vendor', 'gems', model.package_name, 'app', 'assets', 'javascripts', "#{model.namespace.underscore}_desktop", 'view', "#{model.model_name.tableize}", "#{explorer.explorer_name}.js")
  end

  def self.explorer_context_menu_file_name(model, explorer)
    File.join(Rails.root.to_s, 'vendor', 'gems', model.package_name, 'app', 'assets', 'javascripts', "#{model.namespace.underscore}_desktop", 'view', "#{model.model_name.tableize}", "#{explorer.explorer_name}ContextMenu.js")
  end
  
  def self.prepare_config_workers(model, explorer)
    contents = ''
    Buildit::Framework.configuration.scaffolders.buildit_client.each do |worker|
      contents << worker.send(:prepare_explorer_config, model, explorer) || contents if worker.respond_to? :prepare_explorer_config
    end
    contents
  end # def self.prepare_explorer_config
  
  
  def self.prepare_pre_init_workers(model, explorer)
    contents = ''
    Buildit::Framework.configuration.scaffolders.buildit_client.each do |worker|
      contents << worker.send(:prepare_explorer_pre_init, model, explorer) || contents if worker.respond_to? :prepare_explorer_pre_init
    end
    contents
  end # def self.prepare_explorer_pre_init

  def self.prepare_post_init_workers(model, explorer)
    contents = ''
    Buildit::Framework.configuration.scaffolders.buildit_client.each do |worker|
      contents << worker.send(:prepare_explorer_post_init, model, explorer) || contents if worker.respond_to? :prepare_explorer_post_init
    end
    contents
  end # def self.prepare_explorer_post_init
    

  # This is the primary method for generating the contents within the initComponent block
  # of the Explorer.
  def self.explorer_config_contents(model, explorer)

    searchable = 'false'

    model.attribute_meta.each do |attribute|
      unless attribute.search_type.nil?
        searchable = 'true'
        break
      end
    end

    contents = CONF_START_TAG << "\n"
    contents << "  allowFind:      #{searchable},\n\n"
    contents << "  store:          Ext.create('#{model.namespace}.store.#{model.model_name}'),\n\n"
    contents << "  contextMenuConfig:{\n"
    contents << "    xtype:        '#{explorer.context_menu_xtype}',\n"
    contents << "  },\n\n"
    contents << "  inspectorConfig: {\n"
    contents << "    xtype:        '#{explorer.inspector_xtype}'\n"
    contents << "  },\n\n"
    contents << "  newForms:[{\n"
    contents << "    xtype:        '#{explorer.new_form_xtype}',\n"
    contents << "    windowConfig: {}\n"
    contents << "  }],\n"
    contents << '  ' << CONF_END_TAG

    contents
    
  end
  
  
  # This is the primary method for generating the contents within the initComponent block
  # of the Explorer.
  def self.explorer_pre_contents(model, explorer)
    contents = PRE_START_TAG << "\n"
    contents << '    ' << PRE_END_TAG
    contents
  end

  # This is the primary method for generating the contents within the initComponent block
  # of the Explorer.
  def self.explorer_post_contents(model, explorer)
    contents = POST_START_TAG << "\n"
    contents << '    ' << POST_END_TAG
    contents
  end
    
  
  def self.template
<<-EOF
Ext.define('<%= model.namespace %>.view.<%= model.model_name.tableize %>.<%= explorer.explorer_name %>', {

  extend:'Buildit.ux.explorer.Panel',
  alias:'widget.<%= model.namespace.underscore %>-<%= model.model_name.tableize %>-<%= explorer.explorer_name %>',

<%= self.prepare_config_workers(model, explorer) %>

  initComponent:function () {

    var me = this;

<%= self.prepare_pre_init_workers(model, explorer) %>

    this.callParent();

<%= self.prepare_post_init_workers(model, explorer) %>
  }

});
EOF
  end # def self.template
  
  def self.context_menu_template
<<-EOF
Ext.define('<%= model.namespace %>.view.<%= model.model_name.tableize %>.<%= explorer.explorer_name %>ContextMenu', {
  extend: 'Buildit.ux.ContextMenu',
  alias:  'widget.<%= model.namespace.underscore %>-<%= model.model_name.tableize %>-<%= explorer.explorer_name %>ContextMenu',

  
  initComponent: function() {
    var me = this;

    Ext.apply(this, {

      rightActions: [

        // RIGHT ACTIONS (Start) ================================================================

        /**
         * DELETE
         * Supports the deletion of the selected items in the explorer grid. If none
         * are selected then no records are deleted.
         */
        {
          text:'Delete',
          cls: 'icon-delete',
          action: 'delete',
          confirm: true,
          multi: true,
          privileges: [],
          listeners: {
            click: {
              fn: this.clickDelete,
              scope: me
            }
          }
        },

        /**
         * DELETE
         * Supports the deletion of the selected items in the explorer grid. If none
         * are selected then no records are deleted.
         */
        {
          text:'Export',
          cls: 'icon-export',
          action: 'export',
          confirm: true,
          multi: true,
          privileges: [],
          listeners: {
            click: {
              fn: this.clickExport,
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
          text:'Select All',
          cls: 'icon-select-all',
          action: 'select-all',
          confirm: true,
          multi: true,
          privileges: [],
          listeners: {
            click: {
              fn: this.clickSelectAll,
              scope: me
            }
          }
        },


        /**
         * EXPORT
         * Supports the deletion of the selected items in the explorer grid. If none
         * are selected then no records are deleted.
         */
        {
          text:'Deselect All',
          cls: 'icon-deselect-all',
          action: 'deselect-all',
          confirm: true,
          privileges: [],
          listeners: {
            click: {
              fn: this.clickDeselectAll,
              scope: me
            }
          }
        }

        // RIGHT ACTIONS (End)

      ],


      leftActions: [

        // LEFT ACTIONS (Start) =================================================================

        /**
         * NEW
         * Supports the deletion of the selected items in the explorer grid. If none
         * are selected then no records are deleted.
         */
        {
          text: 'New',
          cls: 'icon-new'
        }

        // LEFT ACTIONS (End)

      ]

    });

    this.callParent();
  },



  // ACTION HANDLERS (Start) ====================================================================

  clickDelete: function(btn, e, eOpts){
    Buildit.logic.explorer.action.Delete.click(btn);
  },

  clickExport: function(btn, e, eOpts){
    Buildit.logic.explorer.action.Export.click(btn);
  },

  clickSelectAll: function(btn, e, eOpts){
    Buildit.logic.explorer.action.SelectAll.click(btn);
  },

  clickDeselectAll: function(btn, e, eOpts){
    Buildit.logic.explorer.action.DeselectAll.click(btn);
  },

  clickNew: function(btn, e, eOpts){
    // TODO
  }

  // ACTION HANDLERS (End)

});

EOF
  end # def self.template

  # context menu for STATES ********************************************
  def self.explorer_process_selected_items_file_name(model, explorer)
    File.join(Rails.root.to_s, 'vendor', 'gems', model.package_name, 'app', 'assets', 'javascripts', "#{model.namespace.underscore}_desktop", 'logic', "#{model.table_name}", "#{explorer.explorer_name}ProcessSelectedItems.js")
  end

  def self.context_menu_state_template

<<-EOF
Ext.define('<%= model.namespace %>.view.<%= model.model_name.tableize %>.<%= explorer.explorer_name %>ContextMenuEvent', {
  extend: 'Buildit.ux.ContextMenu',
  alias:  'widget.<%= model.namespace.underscore %>-<%= model.model_name.tableize %>-<%= explorer.explorer_name %>ContextMenuEvent',

  
  initComponent: function() {
    var me = this;

    Ext.apply(this, {

      rightActions: [

        // RIGHT ACTIONS (Start) ================================================================

        /**
         * Event
         * Supports performing 'Event' on the selected items in the explorer grid.
         * If none are selected then no records are deleted.
         */
        {
          text:'Event',
          cls: 'icon-settings',
          action: 'event',
          confirm: true,
          multi: true,
          privileges: [],
          listeners: {
            click: {
              fn: this.clickEvent,
              scope: me
            }
          }
        },

        /**
         * DELETE
         * Supports the deletion of the selected items in the explorer grid. If none
         * are selected then no records are deleted.
         */
        {
          text:'Delete',
          cls: 'icon-delete',
          action: 'delete',
          confirm: true,
          multi: true,
          privileges: [],
          listeners: {
            click: {
              fn: this.clickDelete,
              scope: me
            }
          }
        },

        /**
         * EXPORT
         * Supports the export of the selected items in the explorer grid.
         * 
         */
        {
          text:'Export',
          cls: 'icon-export',
          action: 'export',
          confirm: true,
          multi: true,
          privileges: [],
          listeners: {
            click: {
              fn: this.clickExport,
              scope: me
            }
          }
        },

        // SEPARATOR
        '-',


        /**
         * SELECT ALL
         * Supports the selection of all rows in the grid.
         * 
         */
        {
          text:'Select All',
          cls: 'icon-select-all',
          action: 'select-all',
          confirm: true,
          multi: true,
          privileges: [],
          listeners: {
            click: {
              fn: this.clickSelectAll,
              scope: me
            }
          }
        },


        /**
         * DESELECT ALL
         * Supports the de-selection of all rows in the grid.
         * 
         */
        {
          text:'Deselect All',
          cls: 'icon-deselect-all',
          action: 'deselect-all',
          confirm: true,
          privileges: [],
          listeners: {
            click: {
              fn: this.clickDeselectAll,
              scope: me
            }
          }
        }

        // RIGHT ACTIONS (End)

      ],


      leftActions: [

        // LEFT ACTIONS (Start) =================================================================

        /**
         * NEW
         * Supports the deletion of the selected items in the explorer grid. If none
         * are selected then no records are deleted.
         */
        {
          text: 'New',
          cls: 'icon-new'
        }

        // LEFT ACTIONS (End)

      ]

    });

    this.callParent();
  },


  // ACTION HANDLERS (Start) ====================================================================

  clickEvent: function(btn, e, eOpts){
    Opt.logic.<%= model.table_name %>.ExplorerProcessSelectedItems.click(btn, 'event');
  },

  clickDelete: function(btn, e, eOpts){
    Buildit.logic.explorer.action.Delete.click(btn);
  },

  clickExport: function(btn, e, eOpts){
    Buildit.logic.explorer.action.Export.click(btn);
  },

  clickSelectAll: function(btn, e, eOpts){
    Buildit.logic.explorer.action.SelectAll.click(btn);
  },

  clickDeselectAll: function(btn, e, eOpts){
    Buildit.logic.explorer.action.DeselectAll.click(btn);
  },

  clickNew: function(btn, e, eOpts){
    // TODO
  }

  // ACTION HANDLERS (End)

});

EOF
  end # def self.context_menu_state_template

  def self.process_selected_items_template
<<-EOF
/**
 *  The PROCESS button will be clicked from the context menu bound to the gridview.
 */
Ext.define('<%= model.namespace %>.logic.<%= model.table_name %>.ExplorerProcessSelectedItems', {
  statics: {
    click:function(btn, event_name){
      var explorerGridView = btn.ownerCt.contextOwner.down('grid').getView();
      var selectedItems = explorerGridView.getSelectionModel().getSelection();
      var store = btn.ownerCt.contextOwner.store;

      Ext.Msg.confirm(
        'Process Confirmation',
        'You are about to process the selected row(s), are you sure?',
        function(btn){
          if(btn == 'yes'){
            Ext.each(selectedItems, function(item){
              Opt.service.<%= model.model_name %>.fireEvent(
                {
                  name: event_name, 
                  id: item.get('<%= model.primary_attribute %>')
                },
                function(response, e){
                  if(response.success == true){
                    store.load();
                  }
                }
              );
            });
          };
        }
      );
    }
  }
});
EOF
  end # def self.context_menu_template
  # context menu for STATES ********************************************

end # class Opt::Gen::ExplorerWorker