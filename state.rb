module Carlos
  class State
    include Singleton
    attr_accessor :tasks_performed, :tasks_pending, :handlers_busy

    def initialize
      @tasks_performed = 0
      @tasks_pending = 0
      @handlers_busy = 0
      @mutex = Mutex.new
    end

    def update(&block)
      @mutex.synchronize do
        yield self
      end
    end

    def to_h
      @mutex.synchronize do
        {
          handlers_total:  HandlersPool::SIZE,
          tasks_performed: tasks_performed,
          tasks_running:   handlers_busy,
          tasks_pending:   tasks_pending,
          handlers_busy:   handlers_busy,
          handlers_free:   HandlersPool::SIZE - handlers_busy
        }
      end
    end
  end
end
