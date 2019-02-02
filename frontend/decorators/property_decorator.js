import { application } from '../packs/application';

/**
 * Attribue a ref to a class and register it in Stimulus Application
 * e.g. target.name === HomePageController -> controllerRef === home-page
 * @param {*} target
 */
export function Property(context) {
    return function Property(target, key, descriptor) {
        target.constructor.targets.push(key);

        let v = undefined;
        let newDescriptor = {
            enumerable: true,
            configurable: true,
            get: function() {
                return v;
            },
            set: function(value) {
                v = value;

                let controller = application.getControllerForElementAndIdentifier(
                    this.scope.element,
                    application.getControllerRef(target.name)
                );

                controller[key + 'Target'].textContent = value;

                target.setProperty(key, 'test');
            },
        };

        return newDescriptor;
    };
}
