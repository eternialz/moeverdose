module DeviseHelper
    def devise_error_messages!
        return "" if resource.errors.empty?

        render "/devise/shared/error_messages", resource: resource
    end
end
