require 'algorithms'

module Carlos
  class Queue
    include Singleton
    include MonitorMixin

    def initialize
      @heap = Containers::MaxHeap.new
      @cond = new_cond
      super
    end

    def push(*args)
      synchronize do
        @heap.push(*args)

        State.instance.update do |state|
          state.tasks_pending += 1
        end

        @cond.signal
      end
    end

    def pop
      synchronize do
        @cond.wait_while { @heap.empty? }

        State.instance.update do |state|
          state.tasks_pending -= 1
        end

        @heap.pop
      end
    end
  end
end
