module Rails
    module Rack
        class Logger < ActiveSupport::LogSubscriber
            def started_request_message(request)
                format('Started %s "%s" for %s at %s', request.request_method, request.filtered_path, anonymized_ip(request), Time.now.to_default_s)
            end

            def anonymized_ip(request)
                ip = IPAddr.new(request.ip)
                ip.mask(0).to_s
            end
        end
    end
end
