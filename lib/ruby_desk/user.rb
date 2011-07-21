class RubyDesk::User < RubyDesk::OdeskEntity
  attributes    :timezone, :status, :timezone_offset, :public_url,
                :last_name, :email, :reference, :id, :is_provider, 
                :first_name

  class << self
    # Retrieves all team rooms for the currently logged in user
    def retrieve(connector, reference)
      json = connector.prepare_and_invoke_api_call 'hr/v2/users/' + reference,
          :method => :get
      self.new(json['user'])
    end
  end

  # Create a new UserRole from a hash similar to the one in ActiveRecord::Base.
  # The given hash maps each attribute name to its value
  def initialize(params={})
    params.each do |k, v|
      self.instance_variable_set("@#{k}", v)
    end
  end
end
