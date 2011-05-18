class RubyDesk::HRJob < RubyDesk::OdeskEntity
  attributes    :reference, :title, :job_type, :description, :public_url, 
                :created_time, :created_by, :start_date, :end_date, 
                :filled_date, :cancelled_date, :buyer_team__reference, 
                :buyer_team__id, :buyer_team__name, 
                :buyer_company__reference, :buyer_company__name, 
                :visibility, :budget, :duration, :category, :subcategory, 
                :num_candidates, :num_active_candidates, 
                :num_new_candidates, :last_candidacy_access_time, :status

  # Job cancellation reason codes
  ACCIDENTAL_OPENING_CREATION = '67'
  ALL_POSITIONS_FILLED = '51'
  FILLED_BY_ALTERNATE_SOURCE = '49'
  PROJECT_CANCELLED = '41'
  NO_DEVELOPER_WITH_SKILLS = '34'

  
  def self.post(connector, query_options={})
    json = connector.prepare_and_invoke_api_call(
        'hr/v2/jobs', :method=>:post,
        :auth=>true, :sign=>false, :params=>query_options)
    return json
  end
  
  # Required parameter buyer_team__reference
  # query_options: optional parameters as described on oDesk developer site
  def self.retrieve_all(connector, buyer_team__reference, query_options={})
    query_options[:buyer_team__reference] = buyer_team__reference
    json = connector.prepare_and_invoke_api_call(
        'hr/v2/jobs', :method=>:get,
        :auth=>true, :sign=>false, :params=>query_options)
    jobs = []
    if json['jobs']['job']
      [json['jobs']['job']].flatten.each do |job|
        jobs << self.new(job)
      end 
    end
    return jobs
  end
  
  # Retrieve a specific job
  def self.retrieve(connector, job_reference)
    json = connector.prepare_and_invoke_api_call(
        'hr/v2/jobs/' + job_reference, :method=>:get,
        :auth=>true, :sign=>true, :params=>{})
    job = self.new(json['job'])
    return job
  end
  
  def self.cancel(connector, job_reference, why)
    json = connector.prepare_and_invoke_api_call(
        'hr/v2/jobs/' + job_reference, :method=>:post,
        :auth=>true, :sign=>true, :params=>{:http_method=>"delete",:reason_code => why})
    return json['response']
  end
  
  def self.update(connector, job_reference, query_options={})
    query_options[:http_method] = 'put'
    json = connector.prepare_and_invoke_api_call(
        'hr/v2/job/' + job_reference, :method=>:post,
        :auth=>true, :sign=>false, :params=>query_options)
    return json
  end
end
