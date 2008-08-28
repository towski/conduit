module ConduitHelper
  def collection_select_multiple(object, method,
                                 collection, value_method, text_method,
                                 options = {}, html_options = {})
    real_method = "#{method.to_s.singularize}_ids".to_sym
    collection_select(
      object, real_method,
      collection, value_method, text_method,
      options,
      html_options.merge({
        :multiple => true,
        :name => "#{object}[#{real_method}][]"
      })
    )
  end
  
  def collection_select_multiple_users(object, method,
                                            options = {}, html_options = {})
    collection_select_multiple(
      object, method,
      User.find(:all, :order => :login), :id, :login,
      options, html_options
    )
  end
end
