module ApplicationHelper
    def required_label(form, field, text = nil)
        text ||=field.to_s.humanize
        form.label(field) do
            safe_join([text, content_tag(:span, " *", class: "text-danger")])
        end
    end
end
