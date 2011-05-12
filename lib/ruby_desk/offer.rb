class RubyDesk::Offer < RubyDesk::OdeskEntity
  attributes    :reference, :key, :job__reference, :job__title, 
                :job__description, :buyer_team__reference, :buyer_team__id, 
                :buyer_team__name, :buyer_company__reference, 
                :buyer_company__name, :provider__reference, 
                :provider_team__referebce, :provider_team__id, 
                :provider_team__name, :message_from_buyer, 
                :message_from_provider, :engagement_term, :description, :status,
                :created_time, :created_type, :created_by, :expiration_date, 
                :has_buyer_signed, :has_provider_signed, :signed_by_buyer_user, 
                :signed_by_provider_user, :signed_time_buyer, 
                :signed_time_provider, :my_role, :engagement__reference, 
                :interview_status
  
  # Required parameter buyer_team__reference
  # Useful optional parameter: job__reference
  # query_options: optional parameters as described on oDesk developer site
  def self.retrieve_all(connector, buyer_team__reference, query_options={})
    query_options[:buyer_team__reference] = buyer_team__reference
    json = connector.prepare_and_invoke_api_call(
        'hr/v2/offers', :method=>:get,
        :auth=>true, :sign=>false, :params=>query_options)
    offers = []
    # verify that this is how the data should look
    if json['offers']['offer']
      [json['offers']['offer']].flatten.each do |offer|
        offers << self.new(offer)
      end 
    end
    return offers
  end
  
  def self.retrieve(connector, offer_reference)
    json = connector.prepare_and_invoke_api_call(
        'hr/v2/offers/' + offer_reference, :method=>:get,
        :auth=>true, :sign=>true, :params=>{})
    offer = self.new(json['offer'])
    return offer
  end
end
