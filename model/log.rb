require 'active_record'

configure :test, :development do
  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database => 'log.db'
  )
end

configure :production do
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:log.db")
end

class Log < ActiveRecord::Base
  def date
    self.posted_date.strftime("%Y-%m-%d %H:%M:%S")
  end
end

class LogMigration < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string :from
      t.text :body
      t.timestamp :posted_date
    end
  end
end

LogMigration.new.up unless ActiveRecord::Base.connection.table_exists? 'logs'
