class TemplateRenderer
    def self.render(template_string, data)
        template = Liquid::Template.parse(template_string)
        template.render(data)
    end
end
