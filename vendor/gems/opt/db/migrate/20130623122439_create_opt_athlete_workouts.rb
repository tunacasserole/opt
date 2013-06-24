class CreateOptAthleteWorkouts < ActiveRecord::Migration
  def change
  	ActiveRecord::Base.establish_connection(Buildit::Util::Data::Connection.for('BUILDIT'))
    @connection = ActiveRecord::Base.connection
  	unless ActiveRecord::Base.connection.tables.include?('athlete_workouts')
      create_table(:athlete_workouts, :id => false) do |t|
        t.column   :workout_id,                      :string,            :null  =>  false,   :limit   => 32
        t.column   :athlete_id,                      :string,            :null  =>  true,    :limit   => 32
        t.column   :workout_name,                    :string,            :null  =>  true,    :limit   => 200
        t.column   :state,                           :string,            :null  =>  true,    :limit   => 200
        t.column   :workout_date,                    :date,              :null  =>  true
        t.column   :description,                     :string,            :null  =>  true,    :limit   => 1000
        t.column   :results,                         :string,            :null  =>  true,    :limit   => 1000
        t.column   :is_destroyed,                    :boolean,           :null  =>  true
      end
    end
    ActiveRecord::Base.establish_connection(Buildit::Util::Data::Connection.for('BUILDIT'))
  end
end
