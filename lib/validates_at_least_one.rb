module ActiveRecord
  module Validations
    module ClassMethods

      def validates_at_least_one(*args)        
        configuration = { :message => I18n.translate('activerecord.errors.messages.invalid'),
                          :on => :save, :with => nil, :base_message => true, :attribute_messages => true
                        }
        configuration.update(args.pop) if args.last.is_a?(Hash)

        validates_each(args, configuration) do |record, attr_name, value|
          unless value.select{|s| s.valid?}.size > 0
            next if value.empty?
            
            # the overall error about the invalid object
            record.errors.add(attr_name, configuration[:message]) if configuration[:base_message]

            # error messages for each invalid attribute
            value.select{|s| !s.valid?}.first.errors.each do |attribute, message|
              record.errors.add(attr_name, message)
            end if configuration[:attribute_messages] # each
          end # unless
        end # validates_each
      end # validates_at_least_one

    end    
  end
end
