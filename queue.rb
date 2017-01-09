require 'algorithms'

module Carlos
  class Queue
    include Singleton
    include MonitorMixin

    def initialize
      @tasks_performed = 0
      @tasks_pending = 0
      @tasks_running = 0

      @heap = Containers::MaxHeap.new
      @cond = new_cond

      super
    end

    def done
      synchronize do
        @tasks_running -= 1
        @tasks_performed += 1
      end
    end

    def state_to_h
      synchronize do
        {
          handlers_total:  HandlersPool::SIZE,
          tasks_performed: @tasks_performed,
          tasks_running:   @tasks_running,
          tasks_pending:   @tasks_pending,
          handlers_busy:   @tasks_running,
          handlers_free:   HandlersPool::SIZE - @tasks_running
        }
      end
    end

    def push(*args)
      synchronize do
        @heap.push(*args)
        @tasks_pending += 1
        @cond.signal
      end
    end

    def pop
      synchronize do
        @cond.wait_while { @heap.empty? }
        @tasks_pending -= 1
        @tasks_running += 1
        @heap.pop
      end
    end
  end
end
