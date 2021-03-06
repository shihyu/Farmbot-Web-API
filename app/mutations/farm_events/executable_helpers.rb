module FarmEvents
  module ExecutableHelpers
    NO_EXECUTABLE = "An event requires a sequence or regimen"
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # :required or :optional
      def executable_fields(optionality = "deprecated")
        optional do
          integer :executable_id
          string  :executable_type, in: FarmEvent::EXECUTABLE_CLASSES.map(&:name)
        end
      end
    end

    def validate_executable
        add_error :farm_event, :not_found, NO_EXECUTABLE unless executable
    end

    def executable
      @executable ||= klass.where(id: executable_id).first
    end

    def klass
      ({"Sequence" => Sequence,
        "Regimen"  => Regimen })[executable_type] || Sequence
    end
  end
end
