class Opt::Gen::StateWorker < Opt::Gen::Worker
  
  START_TAG  = '# STATES (Start) ===================================================================='
  END_TAG    = '# STATES (End)'
  
  HANDLER_START_TAG  = '# STATE HANDLERS (Start) ===================================================================='
  HANDLER_END_TAG    = '# STATE HANDLERS (End)'
  
  VALIDATION_START_TAG  = '# STATE VALIDATIONS (Start) ===================================================================='
  VALIDATION_END_TAG    = '# STATE VALIDATIONS (End)'
  
  def self.prepare_model(model)
    standard_template
  end # def self.prepare_model
  
  def self.process_model(model, model_file_contents)
    @machine = Studio::MachineMeta.where(:model_meta_id => model.model_meta_id).first 
    if @machine       
      token = /(#{Regexp.escape(START_TAG)})(.*)(#{Regexp.escape(END_TAG)})/im
      Buildit::Util::String.replace(model_file_contents, self.model_contents(model), token)
    end
  end

  def self.prepare_helper_instance(model)
<<-HELPER_HOOKS

    #{HANDLER_START_TAG}
    #{HANDLER_END_TAG}

    #{VALIDATION_START_TAG}
    #{VALIDATION_END_TAG}

HELPER_HOOKS
  end # def self.prepare_helper
  
  def self.process_helper(model, helper_file_contents)
    puts 'process helper'
    @machine = Studio::MachineMeta.where(:model_meta_id => model.model_meta_id).first 
    if @machine   
      #events = Studio::EventMeta.where(:machine_meta_id => @machine.machine_meta_id)
      token = /(#{Regexp.escape(HANDLER_END_TAG)})/im
      @machine.event_meta.each do |event|
        puts 'event found'
        event.transition_meta.each do |meta|
          puts 'transitition found'
          method_token = /def #{meta.after_transition}/
          unless helper_file_contents =~ method_token
            puts 'helper file contents'
            helper_file_contents = Buildit::Util::String.replace(helper_file_contents, self.state_method_signature(meta), token)
          end
        end
      end
    end
    helper_file_contents
  end  

  private

    def self.model_contents(model)
      puts 'model contents'
      @machine = Studio::MachineMeta.where(:model_meta_id => model.model_meta_id).first  
      puts model.model_meta_id    
      if @machine
        contents = START_TAG
        contents << "\n"
        #events = Studio::EventMeta.where(:machine_meta_id => machine.machine_meta_id)
        if @machine.event_meta
          contents << "  state_machine :state, :initial => :#{@machine.initial_state || 'new'} do\n\n"
          contents << "  ### CALLBACKS ###\n"        
          
          @machine.event_meta.each do |event|
            event.transition_meta.each do |transition|
              contents << "    before_transition :on => :#{transition.event_name}, :do => :#{transition.before_transition}\n" if transition.before_transition
              contents << "    after_transition :on => :#{transition.event_name}, :do => :#{transition.after_transition}\n" if transition.after_transition            
            end
          end
            
          contents << "\n  ### EVENTS ###\n"        
          
          @machine.event_meta.each do |event|
            contents << "    event :#{event.event_name} do\n"
            event.transition_meta.each do |transition|
              contents << "      transition :#{transition.from_state} => :#{transition.to_state}\n"
            end
            contents << "    end\n"
          end
          
          contents << "  end\n"  
          contents << '  ' << END_TAG
          puts contents
          contents
        end
      end
    end

    def self.standard_template
<<-PREP
  #{START_TAG}

  #{END_TAG}
PREP
    end # def self.standard_template

    def self.state_method_signature(transition_meta)
<<-METH

    # #{transition_meta.description || 'No Description Provided'}
    def #{transition_meta.after_transition}

    end # def #{transition_meta.after_transition}

    #{HANDLER_END_TAG}
METH
  end


  end