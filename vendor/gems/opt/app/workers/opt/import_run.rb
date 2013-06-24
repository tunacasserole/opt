class Opt::ImportRun
  @queue = :import_queue

  def self.perform(import_id)
	# @queue = :import_queue  	
    puts "\n******** QUEUEING the IMPORT now ************\n"
    # puts import_id
    Opt::Import::Manager.run_by_id(import_id)
    puts "\n******** END - IMPORT ************\n"    
    puts "\n\nready..."
  end
end
