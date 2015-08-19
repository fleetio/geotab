require "faraday"
require "json"
require "geotab/version"
require "geotab/concerns"
require "geotab/concerns/conditionable"
require "geotab/concerns/connectable"
require "geotab/concerns/findable"
require "geotab/concerns/initializable"
require "geotab/client"
require "geotab/device"
require "geotab/device_status_info"
require "geotab/diagnostic"
require "geotab/failure_mode"
require "geotab/fault_datum"
require "geotab/status_datum"
require "hash"

module Geotab
  def self.config
    yield self
  end

  def self.username
    @username
  end

  def self.username=(value)
    @username = value
  end

  def self.password
    @password
  end

  def self.password=(value)
    @password = value
  end

  def self.database
    @database
  end

  def self.database=(value)
    @database = value
  end

  def self.path
    @path
  end

  def self.path=(value)
    @path = value
  end
end
