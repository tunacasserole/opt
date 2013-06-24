class Opt::Gen::HubWorker < Opt::Gen::Worker

  def self.file_path(gem_name)
    File.join(Rails.root.to_s, 'vendor', 'gems', gem_name, 'app', 'assets', 'javascripts', gem_name + '_desktop', 'view', 'app')
  end
  
  def self.file_name(hub, gem_name)
    File.join(file_path(gem_name), hub + '.js')
  end
  
  def self.destroy(hub, gem_name)
    initiate "Destroying the hub file"
    FileUtils.rm_rf(self.file_name(hub, gem_name)) if File.exists?(self.file_name(hub, gem_name))
    complete
  end # def self.destroy

  def self.run(hub, gem_name)
    initiate "Preparing the hub file"
    FileUtils.mkdir_p(file_path(gem_name))

    # remove the file if it already exists
    file_name = self.file_name(hub, gem_name)
    FileUtils.rm_rf(file_name) if File.exists?(file_name)
    complete

    # create the new file
    File.open(self.file_name(hub, gem_name), 'w') {|file| file.print hub_contents(hub, gem_name)}
    complete

  end

  def self.hub_contents(hub, gem_name)
    #table_hash = {}
    #Buildit::ModelMeta.all.each {|x| table_hash[x.model_name] = x.table_name}
    #Opt::Meta::Base.constants
    #model_headers = File.join(Rails.root,'vendor/gems/opt/db/meta/model_headers.xlsx')
    meta_folder = File.join(Rails.root, 'vendor','gems', gem_name,'db','meta')
    meta_file = 'model_meta.xlsx'
    meta_file = 'mark_meta.xlsx' if hub.start_with? 'Mark'
    meta_file = 'meta.xlsx' if gem_name == 'rms'
    sections = Opt::Meta::Base.excel_to_hash meta_folder, meta_file, 'sections'
    tiles = Opt::Meta::Base.excel_to_hash meta_folder, meta_file, 'tiles'    
    contents = ::ERB.new(self.template).result(binding)
    sections.each do |section|
      next if section['hub'] != hub
      contents << "\n    // Section: #{section['section']} //"
      contents << "\n\t {"
      contents << "\n\t title: '#{section['section'].titleize}',"
      contents << "\n     columns: #{section['columns'].to_s.chop.chop},"
      contents << "\n     rows: #{section['rows'].to_s.chop.chop},"
      contents << "\n     tiles: ["
      tiles.each do |tile|
        next if tile['hub'] != hub
        next if tile['section'] != section['section']
        #table_name = Buildit::ModelMeta.all(:model_name => tile['model_name']).first.table_name
       ### SAMPLE {title: 'Release Title 1 Pick Tickets',  colspan: 2, rowspan: 1, cls: 'release_pick_tickets purple1', badge: '3', target: {xtype: 'opt-pick_tickets-Explorer', title: 'Release Title 2 Pick Tickets',  defaultSearch: {with: {state: {equal_to: 'new'}}}, contextMenuConfig: {xtype: 'opt-pick_tickets-ExplorerContextMenuRelease'}, store: Ext.create('Opt.store.PickTicket', {storeId: 'ReleasePickTicketStore'}), allowNew: false}},        #puts "tiles" + tile['color']
        #table_name = table_hash[tile['model_name']]
        table_name = tile['table_name']
        #puts table_name
        title = "title: '#{tile['tile_title']}'"
        cls = "cls: '#{tile['event']}_#{table_name} #{tile['color']}'"
        badge = "badge: '3', " if tile['badge']
        colspan = "colspan: #{tile['colspan'].to_s.chop.chop}"
        rowspan = "rowspan: #{tile['rowspan'].to_s.chop.chop}"
        #xtype = "xtype: 'opt-#{table_name}-Explorer'"
        xtype = "xtype: 'opt-#{tile['model_name'].tableize}-Explorer'"
        explorer_title = "title: '#{tile['explorer_title']}'" #if tile['explorer_title']
        default_search =  "with: {state: {equal_to: '#{tile['state_equal_to']}'}}" if tile['state_equal_to']
        default_search =  "with: {state: {any_of: [#{tile['state_any_of']}]}}" if tile['state_any_of']
        
        target = "target: {#{xtype}, #{explorer_title}"
        if tile['event']
          defaultSearch = ", defaultSearch: { #{default_search} }" if default_search
          contextMenuConfig = "contextMenuConfig: {xtype: 'opt-#{table_name}-ExplorerContextMenu#{tile['event'].titleize}'}"
          storeId = "{storeId: '#{tile['event'].titleize + tile['model_name']}Store'}"
          store = "store: Ext.create('#{gem_name}.store.#{tile['model_name']}',#{storeId})"
          target += "#{defaultSearch}, #{contextMenuConfig}, #{store}, allowNew: false"
        end         
        target += "}"

        contents << "\n       {#{title}, #{colspan}, #{rowspan}, #{cls}, #{badge} #{target}},"
      end

      contents.chop!
      contents << "\n\t\t ] \n\t\t },"
    end
    contents.chop!
    contents << " \n ] \n }); \n this.callParent(); \n } \n });"
    
  end
  
  private
  
  def self.template
<<-EOF
//= require ./HubContextMenu

Ext.define('<%= gem_name.titleize %>.view.app.<%= hub %>', {
	extend: 'Buildit.ux.Hub',
	alias: 'widget.<%= gem_name %>-app-<%= hub %>',
	bodyStyle: 'background: transparent',
    cls: 'desktop',

  initComponent: function(){
    var me = this;  
    Ext.apply(this, {
      title: 'Start',
      subtitle: '',
      contextMenuConfig: {
        xtype: '<%= gem_name %>-app-HubContextMenu'
      },

      sections: [
EOF
  end

end

