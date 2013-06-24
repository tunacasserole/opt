class Opt::Athlete < ActiveRecord::Base


  # MIXINS (Start) ======================================================================

  # MIXINS (End)


  # METADATA (Start) ====================================================================
  self.establish_connection       Buildit::Util::Data::Connection.for 'BUILDIT'
  self.table_name                 = :athletes
  self.primary_key                = :athlete_id
  # METADATA (End)


  # BEHAVIOR (Start) ====================================================================
  #supports_logical_delete
  #supports_audit
  #supports_revisioning
  #supports_fulltext
  # BEHAVIOR (End)


  # VALIDATIONS (Start) =================================================================
  validates :athlete_id,                        :presence      => true
  # VALIDATIONS (End)


  # DEFAULTS (Start) ====================================================================
  default :athlete_id,                          :with => :guid
  default :full_name,                           :override  =>  false,        :to    => lambda{|m| "#{m.first_name} #{m.last_name}"}  
  # DEFAULTS (End)


  # ASSOCIATIONS (Start) ================================================================
  
  # ASSOCIATIONS (End)


  # MAPPED ATTRIBUTES (Start) ===========================================================
  
  # MAPPED ATTRIBUTES (End)

  
  # COMPUTED ATTRIBUTES (Start) =========================================================
  
  # COMPUTED ATTRIBUTES (End)


  # TEMPORARY ATTRIBUTES (Start) ========================================================
  
  # TEMPORARY ATTRIBUTES (End)


  # FILTERS (Start) =====================================================================
  
  # FILTERS (End)


  # ORDERING (Start) ====================================================================
  
  # ORDERING (End)


  # SCOPES (Start) ======================================================================
  
  # SCOPES (End)


  # INDEXING (Start) ====================================================================
  
  # INDEXING (End)


  # HOOKS (Start) =======================================================================

  # HOOKS (End)


  # STATES (Start) ====================================================================
  
  # STATES (End)
  
  # EVENTFUL (Start) =========================================================================
  eventful do 
    after :create, :if => true, :publish => "new athlete was created"
  end
  # EVENTFUL (End) ===========================================================================

  # HELPERS (Start) =====================================================================

  # HELPERS (End)

end # class Opt::Athlete