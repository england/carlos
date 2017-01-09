require 'etc'
require 'drb'

module Carlos
  class HandlersPool
    SIZE = Etc.nprocessors
    DRB_URI = 'druby://localhost:9999'

    def initialize
      queue = DRbObject.new_with_uri(DRB_URI)

      SIZE.times do |i|
        fork do
          sleep 1

          loop do
            task = queue.pop
            p task

            # fibonacci(task)
            sleep task

            queue.done
          end
        end
      end

      DRb.start_service DRB_URI, Carlos::Queue.instance
    end

    private

    def fibonacci(n)
      return n if (0..1).include? n
      fibonacci(n - 1) + fibonacci(n - 2)
    end
  end
end
