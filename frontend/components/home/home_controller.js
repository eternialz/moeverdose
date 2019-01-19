// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from 'stimulus';
import { RegisterController } from '../../decorators/register_controller_decorator';

@RegisterController
class HomeController extends Controller {
    static targets = ['output'];

    initialize() {
        this.outputTarget.textContent = 'Hello, Stimulus!';
    }
}
