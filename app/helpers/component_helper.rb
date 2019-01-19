module ComponentHelper
    def componentPath(component_name)
        name = component_name.split("_").first
        return "components/#{name}/#{component_name}"
    end

    def component(component_name, locals = {}, &block)
        render(componentPath(component_name), locals, &block)
    end
end
