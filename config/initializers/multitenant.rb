# opening Active record module
module ActiveRecord
  # opening Base class
  class Base
    # Adding multi tenancy functionality
    def self.inherited(child)
      super
      return if child.name.include?('ActiveRecord') || child.abstract_class? # ActiveRecord::SchemaMigration

      # adding an attribute for multi-tenancy and related methods
      child.instance_eval do
        # default value for all models is assumed to be true
        @multitenant = true

        def multitenant?
          @multitenant
        end

        def not_multitenant
          @multitenant = false
        end
      end

      trace = TracePoint.trace(:end) do |tp|
        if tp.self == child
          trace.disable
          if child.multitenant?
            child.instance_eval do
              default_scope { where(company_id: Company.current_id) }
            end
          end
        end
      end
    end
  end
end
