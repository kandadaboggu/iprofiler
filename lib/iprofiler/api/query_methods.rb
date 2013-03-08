module Iprofiler
  module Api

    module QueryMethods

      def company_lookup(options={})
        get(company_lookup_path, options)
      end

    private

      def company_lookup_path
        "/ip.json"
      end

    end

  end
end
