require 'grape'
require_relative 'api'
require_relative 'queue'
require_relative 'handlers_pool'

Carlos::HandlersPool.new

run Carlos::Api
