require "faraday"
require "json"
require "geotab/version"
require "geotab/concerns"
require "geotab/concerns/conditionable"
require "geotab/concerns/connectable"
require "geotab/concerns/findable"
require "geotab/concerns/initializable"
require "geotab/client"
require "geotab/defect"
require "geotab/device"
require "geotab/device_status_info"
require "geotab/diagnostic"
require "geotab/dvir_log"
require "geotab/failure_mode"
require "geotab/fault_datum"
require "geotab/log_record"
require "geotab/status_datum"
require "geotab/exceptions"
require "hash"

module Geotab
  def self.config
    yield self
  end

  def self.with_connection(connection)
    Thread.current[:geotab_connection_block] = connection
    yield
  ensure
    Thread.current[:geotab_connection_block] = nil
  end

  def self.has_config?
    username && password && path
  end

  def self.username
    Thread.current[:geotab_username]
  end

  def self.username=(value)
    Thread.current[:geotab_username] = value
  end

  def self.password
    Thread.current[:geotab_password]
  end

  def self.password=(value)
    Thread.current[:geotab_password] = value
  end

  def self.database
    Thread.current[:geotab_database]
  end

  def self.database=(value)
    Thread.current[:geotab_database] = value
  end

  def self.path
    Thread.current[:geotab_path]
  end

  def self.path=(value)
    Thread.current[:geotab_path] = value
  end

  def self.connection_block
    Thread.current[:geotab_connection_block]
  end
end
