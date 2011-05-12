# Custom Payment (i.e. "bonus")
class RubyDesk::CustomPayment < RubyDesk::OdeskEntity
  def self.post(connector, team_ref, query_options={})
    json = connector.prepare_and_invoke_api_call(
        'hr/v2/teams/' + team_ref + '/adjustments', :method=>:post,
        :auth=>true, :sign=>false, :params=>query_options)
    return json
  end
  # TODO: GET version ("list of data" as oDesk API says)
end
