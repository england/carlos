require 'grape'
require_relative 'api'
require_relative 'queue'
require_relative 'handlers_pool'
require_relative 'state'

Carlos::State.instance
Carlos::Queue.instance
Carlos::HandlersPool.instance

run Carlos::Api

