module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_chef

    def connect
      self.current_chef = find_current_user
      #self.current_chef = Chef.find_by(id: cookies.signed[:chef_id])
    end

    def disconnect

    end

    protected
    def find_current_user
      puts '-------------------------------'
      puts Chef.find_by(id: cookies.signed[:chef_id])
      puts '-------------------------------'
      puts current_chef
      Chef.find_by(id: cookies.signed[:chef_id])
      if current_chef = Chef.find_by(id: cookies.signed[:chef_id])
        current_chef
      else
        reject_unauthorized_connection
      end
    end
  end
end
