class Search

  def initialize(params)
      @params = params.delete_if do |k, v|
        if v.kind_of? Hash
          is_delete = true
          v.map { is_delete = false if not v.empty?  }
          is_delete
        else
          v.empty?
        end
      end # => {:field => :value, ...}
      @model = convert_to_model
  end

  def find
     @model.where(conditions)
  end

  protected
  def convert_to_model
    # ProtocolSearch -> Protocol
    eval(self.class.to_s.split("Search")[0])
  end

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    puts @params.inspect
    @params.map do |field, value|
      method_name = "by_#{field}"
      if respond_to? method_name
        # check count arguments
        args_count = self.class.instance_method(method_name.to_sym).arity 
        if args_count.zero?
          send(method_name).compact          
        elsif args_count == 1
          send(method_name, value).compact
        else
          logger.error "Count arguments in #{method_name} greater than one!"
          return []
        end
      else
         logger.error "Undefined method #{method_name}!"
         return []
      end
    end
  end
end