module Iprofiler
  module Api

    module QueryMethods

      def company_lookup(options={})
        path = ip_path(options)
        simple_query(path, options)
      end


      private

        def simple_query(path, options={})
          fields = options.delete(:fields) || Iprofiler.default_profile_fields

          if options.delete(:public)
            path +=":public"
          elsif fields
            path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
          end

          headers = options.delete(:headers) || {}
          params  = options.map { |k,v| "#{k}=#{v}" }.join("&")
          path   += "?#{params}" if not params.empty?

          Mash.from_json(get(path, headers))
        end

        def ip_path(options)
          path = "/people/"
          if id = options.delete(:id)
            path += "id=#{id}"
          elsif url = options.delete(:url)
            path += "url=#{CGI.escape(url)}"
          else
            path += "~"
          end
        end

    end

  end
end
