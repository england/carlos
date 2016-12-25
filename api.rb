module Carlos
  class Api < Grape::API
    format :json

    params do
      requires :task,     type: Integer
      requires :priority, type: Integer
    end
    get :new_task do
      Queue.instance.push params.priority, params.task
      {}
    end

    get :status do
      State.instance.to_h
    end
  end
end
