module Iprofiler
  module Errors
    class IprofilerError < StandardError
      attr_reader :data
      def initialize(data)
        @data = data
        super
      end
    end

    class UnauthorizedError      < IprofilerError; end
    class GeneralError           < IprofilerError; end
    class AccessDeniedError      < IprofilerError; end

    class UnavailableError       < StandardError; end
    class InformIprofilerError    < StandardError; end
    class NotFoundError          < StandardError; end
  end
end
