namespace :build do

  task :system, [:worker, :model] => :environment do |t, args|
    # worker options: meta, service, client, data, all
    puts "\n== starting " << Time.now.strftime("%H:%M:%S").yellow << " ============ "       
    @start_time = Time.now

    if !args[:model_name]
      Buildit::Framework.configuration.scaffolders.opt_meta.reject! {|x| [Opt::Meta::Destroy,Opt::Meta::Service,Opt::Meta::Client].include? x}
      Opt::Meta::Manager.run_all :verbose => true
    else
      Opt::Meta::Manager.run(args[:model_name], :verbose => true)
    end

    puts "== finished in #{(Time.now - @start_time).round(0).to_s.cyan}s"
    puts "==================================="
  end
end

namespace :opt do

  task :meta, [:model_name] => :environment do |t, args|
    ### Sample:  rake opt:import['Hub']
    puts "\n== starting " << Time.now.strftime("%H:%M:%S").yellow << " ============ "       
    @start_time = Time.now

    if !args[:model_name]
      Buildit::Framework.configuration.scaffolders.opt_meta.reject! {|x| [Opt::Meta::Destroy,Opt::Meta::Service,Opt::Meta::Client].include? x}
      Opt::Meta::Manager.run_all :verbose => true
    else
      Opt::Meta::Manager.run(args[:model_name], :verbose => true)
    end

    puts "== finished in #{(Time.now - @start_time).round(0).to_s.cyan}s"
    puts "==================================="
  end

  task :service, [:model_name] => :environment do |t, args|
    ### Sample:  rake opt:import['Hub']
    puts "\n== starting " << Time.now.strftime("%H:%M:%S").yellow << " ============ "       
    @start_time = Time.now

    Buildit::Framework.configuration.scaffolders.opt_meta.reject! {|x| x != Opt::Meta::Service}
    if !args[:model_name]
      Opt::Meta::Manager.run_all :restart => args[:model_name]
    else
      Opt::Meta::Manager.run_all :restart => args[:model_name]
      system ("rake buildit:api") 
    end

    puts "== finished in #{(Time.now - @start_time).round(0).to_s.cyan}s"
    puts "==================================="
  end

  task :client, [:model_name] => :environment do |t, args|
    ### Sample:  rake opt:import['Hub']
    puts "\n== starting " << Time.now.strftime("%H:%M:%S").yellow << " ============ "       
    @start_time = Time.now

    Buildit::Framework.configuration.scaffolders.opt_meta.reject! {|x| x != Opt::Meta::Client}
    if args[:model_name]
      Opt::Meta::Manager.run_all :restart => args[:model_name]
    else
      Opt::Meta::Manager.run_all
    end

    puts "== finished in #{(Time.now - @start_time).round(0).to_s.cyan}s"
    puts "==================================="
  end
  
  task :import, [:model_name] => :environment do |t, args|
    ### Sample:  rake opt:import['Location']
    puts "\n==================================="    
    puts "== seeding application  " << Time.now.strftime("%H:%M:%S").yellow        
    @start_time = Time.now

    Opt::Import::Base.constants

    if !args[:model_name]
      #Opt::Import::Sequence.run_all
      #Opt::Import::Lookup.run_all
      Opt::Import::Manager.run_all
    else
      #Opt::Import::Manager.run args[:model_name]
      Opt::Import::Manager.run_all :restart=>"#{args[:model_name]}"
    end

    puts "== seeded application in #{(Time.now - @start_time).round(0).to_s.cyan}s"
    puts "===================================\n\n"
  end

  task :hub, [:hub_name, :gem_name] => :environment do |t, args|
    ### Sample:  rake opt:hub['ParkerHub']
    puts "==================================="    
    puts "== generating " << args[:hub_name] << " " << Time.now.strftime("%H:%M:%S").yellow        
    @start_time = Time.now

    Opt::Gen::HubWorker.run args[:hub_name], args[:gem_name]

    puts "== generated hub in #{(Time.now - @start_time).round(0).to_s.cyan}s"
    puts "===================================\n\n"
  end

  task :state, [:model_name] => :environment do |t, args|
    ### Sample:  rake opt:import['Hub']
    puts "==================================="    
    puts "== generating all states " #<< args[:hub_name] << " " << Time.now.strftime("%H:%M:%S").yellow        
    @start_time = Time.now

    Opt::Gen::StateWorker.run args[:model_name]

    puts "== generated states in #{(Time.now - @start_time).round(0).to_s.cyan}s"
    puts "===================================\n\n"
  end

  task :seed, [:type,:model_name] => :environment do |t, args|
    puts "==================================="
    puts "== generating  Seeds  #{Time.now.strftime("%H:%M:%S").yellow}"
    @start_time = Time.now

    if args[:type] == "r"
      Opt::Gen::SeedWorker.run :restart=>"#{args[:model_name]}"
    else
      if args[:type] == "s"
        Opt::Gen::SeedWorker.run  :type=>"single",:restart=>"#{args[:model_name]}"
      else
        if args[:type] == "t"
          Opt::Gen::SeedWorker.run  :type=>"table",:mark_model=>"#{args[:model_name]}"
        else
        Opt::Gen::SeedWorker.run
        end
      end
    end

    puts "== generated seed in #{(Time.now - @start_time).round(0).to_s.cyan}s"
    puts "===================================\n\n"
  end

  task :excel, [:model_name] => :environment do |t, args|
    ### Sample:  rake opt:import['Hub']
    puts "==================================="    
    puts "\n== generating excel template " << Time.now.strftime("%H:%M:%S").yellow        
    
    @start_time = Time.now
    
    if !args[:model_name]
      Opt::Gen::ExcelWorker.run_all
    else
      #puts args[:model_name]
      model = Buildit::ModelMeta.all(:model_name => args[:model_name]).first
      #puts model.model_name
      Opt::Gen::ExcelWorker.run model
    end
    
    puts "== generated excel template in #{(Time.now - @start_time).round(0).to_s.cyan}s"
    puts "===================================\n\n"
  end

  task :api => :environment do |t, args|
    ### Sample:  rake opt:import['Hub']
    puts "==================================="    
    puts "== generating shared files " << Time.now.strftime("%H:%M:%S").yellow        
    @start_time = Time.now
    
    #model = Buildit::ModelMeta.all(:model_name => args[:model_name]).first
    system ('rake buildit:api')
    system ('rake buildit:i18n')
    system ('rake buildit:sources')

    puts "== generated shared files in #{(Time.now - @start_time).round(0).to_s.cyan}s"
    puts "===================================\n\n"
  end

  task :lookup => :environment do |t, args|
    ### Sample:  rake opt:import['Hub']
    puts "==================================="    
    puts "== importing lookups " << Time.now.strftime("%H:%M:%S").yellow        
    @start_time = Time.now
    
    #model = Buildit::ModelMeta.all(:model_name => args[:model_name]).first
    Opt::Import::Base.constants
    Opt::Import::Sequence.run_all
    Opt::Import::Lookup.load_meta
    Buildit::Lookup::Manager.generate('opt')

    puts "== imported lookups in #{(Time.now - @start_time).round(0).to_s.cyan}s"
    puts "===================================\n\n"
  end

  task :search => :environment do |t, args|
    ### Sample:  rake opt:import['Hub']
    puts "==================================="    
    #puts "== generating search block " << Time.now.strftime("%H:%M:%S").yellow        
    @start_time = Time.now
    
    #model = Buildit::ModelMeta.all(:model_name => args[:model_name]).first
    Opt::Meta::Search.run_all

    #puts "== generated search block in #{(Time.now - @start_time).round(0).to_s.cyan}s"
    puts "===================================\n\n"
  end

  desc "Runs only demo based seed files from each registered GEM and the host application"
  task :demo, [:gem_name]  => :environment do |t, args|
     #Rake::Task["buildit:db:seed"].invoke
     puts "Running demo seeds for #{args[:gem_name]}"
     puts Rails.root.to_s
     Opt::Data::Seeder.run :gem_name => "#{args[:gem_name]}"
  end
  

end # namespace opt`