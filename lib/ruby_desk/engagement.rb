class RubyDesk::Engagement < RubyDesk::OdeskEntity
  attributes    :reference, :offer_reference, :job__reference, :job__title, 
                :job__description, :buyer_team__reference, :buyer_team__id, 
                :buyer_team__name, :buyer_company__reference, 
                :buyer_company__name, :provider__reference, 
                :provider_team__referebce, :provider_team__id, 
                :provider_team__name, :created_time, :engagement_term, 
                :engagement_title, :engagement_job_type, :hourly_pay_rate, 
                :hourly_charge_rate, :payment_guarantee_date, 
                :fixed_price_amount, :fixed_price_upfront_payment, 
                :weekly_stipend_amount, :weekly_stipend_hours, 
                :weekly_hours_limit, :engagement_start_date, 
                :engagement_end_date
  
  # Required parameter buyer_team__reference
  # Useful optional parameter: job__reference
  # query_options: optional parameters as described on oDesk developer site
  def self.retrieve_all(connector, buyer_team__reference, query_options={})
    query_options[:buyer_team__reference] = buyer_team__reference
    json = connector.prepare_and_invoke_api_call(
        'hr/v2/engagements', :method=>:get,
        :auth=>true, :sign=>false, :params=>query_options)
    engagements = []
    # verify that this is how the data should look
    if json['engagements']['engagement']
      [json['engagements']['engagement']].flatten.each do |engagement|
        engagements << self.new(engagement)
      end 
    end
    return engagements
  end
  
  def self.retrieve(connector, engagement_reference)
    json = connector.prepare_and_invoke_api_call(
        'hr/v2/engagements/' + engagement_reference, :method=>:get,
        :auth=>true, :sign=>true, :params=>{})
    offer = self.new(json['offer'])
    return offer
  end
end
