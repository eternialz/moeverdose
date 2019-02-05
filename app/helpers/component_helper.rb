module ComponentHelper
    def component(component_path, locals = {}, &block)
        path_array = component_path.downcase.split('/')
        name = path_array.pop
        component_path = path_array.join('/')
        render("components/#{component_path}/#{name}/#{name}", locals, &block)
    end
end
