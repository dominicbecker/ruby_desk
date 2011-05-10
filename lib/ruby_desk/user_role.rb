class RubyDesk::UserRole
  # Attribute readers for all attributes
  attributes    :parent_team__id, :user__first_name, :permissions, 
                :company__reference, :user__last_name, :team__is_hidden, 
                :reference, :team__reference, :affiliation_status, 
                :user__reference, :user__is_provider, :parent_team__name, 
                :has_team_room_access, :parent_team__reference, :team__id, 
                :engagement__reference, :team__name, :company__name, :role, 
                :user__id

  class << self
    # Retrieves all team rooms for the currently logged in user
    def get_userroles(connector)
      json = connector.prepare_and_invoke_api_call 'hr/v2/userroles',
          :method=>:get

      user_roles = []
      [json['userroles']['userrole']].flatten.each do |userrole|
        # Append given UserRole to array
        user_roles << self.new(userrole)
      end
      # return the resulting array
      user_roles
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
