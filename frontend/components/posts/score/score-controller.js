import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';

@RegisterController
class PostScoreController extends Controller {
    static targets = ['overdose', 'shortage'];

    connect() {
        console.log('a');
        this.computeScore();
    }

    computeScore() {
        let overdose = this.overdoseTarget.getAttribute('data-score');
        let shortage = this.shortageTarget.getAttribute('data-score');
        let total = parseInt(overdose, 10) + parseInt(shortage, 10);

        let overdoseBasis = total > 0 ? (overdose / total) * 100 : 50;

        this.overdoseTarget.style.flexBasis = overdoseBasis.toString() + '%';
        this.shortageTarget.style.flexBasis = (100 - overdoseBasis).toString() + '%';
    }
}
