import { application } from '../packs/application';

/**
 * Attribue a ref to a class and register it in Stimulus Application
 * e.g. target.name === HomePageController -> controllerRef === home-page
 * @param {*} target
 */
export function RegisterController(target) {
    const controllerRef = target.name
        .split(/(?=[A-Z])/)
        .slice(0, -1)
        .join('-')
        .toLowerCase();
    application.register(controllerRef, target);
}
