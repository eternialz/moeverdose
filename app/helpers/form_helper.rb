module FormHelper
    def error(form, field)
        errors = form.object.errors.full_messages_for(field).join(", ")
        if errors
            return "<div class=\"form-error\">#{errors}</div>".html_safe
        end
    end
end
