class Opt::Gen::SearchWorker < Opt::Gen::Worker
  
  START_TAG  = '# INDEXING (Start) ===================================================================='
  END_TAG    = '# INDEXING (End)'
  
  def self.prepare_model(model)
<<-PREP
  #{START_TAG}

  #{END_TAG}
PREP
  end

  def self.process_model(model, model_file_contents)
    token = /(#{Regexp.escape(START_TAG)})(.*)(#{Regexp.escape(END_TAG)})/im
    Buildit::Util::String.replace(model_file_contents, self.model_contents(model), token) # AARON - adding searchable block
  end

  private
  
    def self.model_contents(model)
      contents = START_TAG
      contents << "\n"

      # AARON - adding searchable block
      contents << "  searchable do\n"
      #puts "  \nsearchable do\n"

      attrs = []
      explorer = Buildit::ExplorerMeta.all(:model_meta_id => model.model_meta_id).first  
      explorer.column_meta.each do |c|
        attr = Buildit::AttributeMeta.find(c.attribute_meta_id)
        #puts "attribute is " + attr.attribute_name
        if attr.mapping_type == 'DIRECT'
          ### DIRECT ATTRIBUTES ####
          v = Buildit::ValidationMeta.all(:attribute_meta_id => attr.attribute_meta_id, :validation_type => 'lookup').first
          if v
            ### LOOKUP ####
            contents << "    string   :" + attr.attribute_name + " do |x| Buildit::Lookup::Manager.display_for('#{v.validation_value}', x.#{attr.attribute_name}) end\n"
            #puts "    string   :" + attr.attribute_name + " do |x| Buildit::Lookup::Manager.display_for('#{v.validation_value}', x.#{attr.attribute_name}) end\n"
          else
            ### BASIC FIELD ###
            #search_type = attr.search_type || attr.field_type
            contents << "    #{search_types(attr.field_type).downcase.ljust(7)}  :#{attr.attribute_name}\n"
            #puts "    #{search_types(attr.field_type).downcase.ljust(7)}  :#{attr.attribute_name}\n"
          end
        else 
          ### MAPPED ATTRIBUTES ####
          a_name = attr.attribute_name.gsub(",","")
          m_field = attr.mapped_field
          contents << "    string   :#{a_name} do #{m_field} if #{m_field.gsub('.display','').gsub('.full_name','')} end\n"
          #puts "    string   :#{a_name} do #{m_field} if #{m_field.gsub('.display','').gsub('.full_name','')} end\n"
        end
      end

      ### POLYMORPHIC KEYS ###
      poly_name = poly_names model
      if poly_name
        contents << "    string   :#{poly_name}_id\n"
        contents << "    string   :#{poly_name}_type\n"
      end

      ### STATE ###
      if Buildit::AttributeMeta.all(:model_meta_id => model.model_meta_id, :attribute_name => 'state').first
        contents << "    string   :state\n"
      end

      contents << " \n"   
      #puts " \n"

      explorer.column_meta.each do |c|
        attr = Buildit::AttributeMeta.find(c.attribute_meta_id)
        next if attr.field_type == 'DATE' or attr.field_type == 'BOOLEAN'
        #puts "attribute is " + attr.attribute_name
        contents << "    text     :#{attr.attribute_name}_fulltext, :using => :#{attr.attribute_name}\n"
        #puts "    text     :#{attr.attribute_name}_fulltext, :using => :#{attr.attribute_name}\n"
      end
      contents << "  end \n"
      # puts "  end \n"         
      # AARON - END

      contents << '  ' << END_TAG << "\n" 
      contents
    end

    def self.poly_names(model)
      poly_names={'PickTicket'=>'pickable','Shipment'=>'shippable','StockLedgerActivity'=>'stockable','WorkOrder'=>'workable'}
      return poly_names[model.model_name]
    end
    
    def self.search_types(attribute_type)
      #puts 
      search_types={'STRING'=>'STRING','DATE'=>'DATE','DECIMAL'=>'INTEGER','BOOLEAN'=>'BOOLEAN'}
      return search_types[attribute_type] || 'STRING'
    end

	end