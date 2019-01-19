import { application } from '../packs/application';

export function RegisterController(target) {
    const controllerRef = target.name
        .split(/(?=[A-Z])/)
        .slice(0, -1)
        .join('-')
        .toLowerCase();
    application.register(controllerRef, target);
}
