module SitesHelper
  require 'pagy/extras/bootstrap'
  include Pagy::Frontend
  
  def format_params(params, order_field)
    result = params.except(:action, 
                          :controller, 
                          :commit, 
                          :order_by_address, 
                          :order_by_name, 
                          :order_by_last_visit
                    ).as_json.to_query

    result << "&#{order_field}=#{params[order_field]=="asc" ? "desc" : "asc"}"
  end
end
