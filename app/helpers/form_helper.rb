module FormHelper
    def error(form, field)
        errors = form.object.errors.full_messages_for(field).join(', ')
        return "<div class=\"form-error\">#{errors}</div>".html_safe if errors
    end
end
