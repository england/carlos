module Carlos
  class HandlersPool
    include Singleton
    SIZE = 1000

    def initialize
      SIZE.times do |i|
        Thread.new do
          loop do
            task = Queue.instance.pop
            p task

            State.instance.update do |state|
              state.handlers_busy += 1
            end

            sleep task

            State.instance.update do |state|
              state.handlers_busy -= 1
              state.tasks_performed += 1
            end
          end
        end
      end
    end
  end
end
