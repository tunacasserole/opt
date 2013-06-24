class CreateOptAthletes < ActiveRecord::Migration
  def change
  	ActiveRecord::Base.establish_connection(Buildit::Util::Data::Connection.for('BUILDIT'))
    @connection = ActiveRecord::Base.connection
  	unless ActiveRecord::Base.connection.tables.include?('athletes')
      create_table(:athletes, :id => false) do |t|
        t.column   :athlete_id,                      :string,            :null  =>  false,   :limit   => 32
        t.column   :first_name,                      :string,            :null  =>  true,    :limit   => 200
        t.column   :last_name,                       :string,            :null  =>  true,    :limit   => 200
        t.column   :full_name,                       :string,            :null  =>  true,    :limit   => 200
        t.column   :is_destroyed,                    :boolean,           :null  =>  true
      end
    end
    ActiveRecord::Base.establish_connection(Buildit::Util::Data::Connection.for('BUILDIT'))
  end
end
