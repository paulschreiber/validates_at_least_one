module ActiveRecord
  module Validations
    module ClassMethods

      def validates_at_least_one(*args)        
        configuration = { :message => I18n.translate('activerecord.errors.messages.invalid'),
                          :on => :save, :with => nil
                        }
        configuration.update(args.pop) if args.last.is_a?(Hash)

        validates_each(args, configuration) do |record, attr_name, value|
          unless value.select{|s| s.valid?}.size > 0
            record.errors.add(attr_name, configuration[:message])
          end
        end
      end

    end    
  end
end
