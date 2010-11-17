module ActiveRecord
  module Validations
    module ClassMethods

      def validates_at_least_one(*args)
        configuration = {
                          :message => I18n.translate('activerecord.errors.messages.invalid'),
                          :on => :save, :with => nil,
                          :base_message => true,
                          :attribute_messages => true,
                          :required_field => false
                        }
        configuration.update(args.pop) if args.last.is_a?(Hash)
        
        validates_each(args, configuration) do |record, attr_name, value|
          # if values is an empty array, display the error message for the overall object and stop
          if value.empty?
            record.errors.add(attr_name, configuration[:message])
            next
          end
                    
          # if all objects are invalid
          if value.select{|s| s.valid?}.size == 0
            
            # collect error messages for each invalid attribute
            # we do this so we can check required_field
            error_messages = {}
            value.select{|s| !s.valid?}.first.errors.each do |attribute, message|
              error_messages[attribute] = message
            end

            required_field_missing = (configuration[:required_field].is_a?(Symbol) and error_messages.has_key?(configuration[:required_field].to_s))
            
            # error message for the overall object appears if
            # (a) base_message is true, and
            #   (b) no required field is specified, or,
            #   (c) the required field is specified and missing
            if configuration[:base_message] and required_field_missing
              record.errors.add(attr_name, configuration[:message])
            end

            # error messages for each invalid attribute appear if
            # (a) attribute_message is true, and
            #   (b) no required field is specified, or,
            #   (c) the required field is specified and rpesent
            error_messages.each do |attribute, message|
              record.errors.add(attr_name, message)
            end if (configuration[:attribute_messages] and !required_field_missing)
            
          end # if
        end # validates_each
      end # validates_at_least_one

    end    
  end
end
