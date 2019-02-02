module ComponentHelper
    def componentPath(component_name)
        name = component_name.split("_").first
        return "components/#{name}/_#{component_name}"
    end

    def component(component_name, locals = {}, &block)
        name = component_name.split("_").first
        render("components/#{name}/#{component_name}", locals, &block)
    end
end
