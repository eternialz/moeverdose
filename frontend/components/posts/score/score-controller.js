import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';
import { PostService } from '../../../services/post-service';
import { RouteService } from '../../../services/route-service';

@RegisterController
class PostScoreController extends Controller {
    static targets = ['overdoseBar', 'shortageBar', 'overdoseScore', 'shortageScore'];

    connect() {
        // Compute initial sizes
        this.computeScore();
    }

    /**
     * Compute current score and set score bar sizes
     */
    computeScore() {
        let overdose = this.overdoseBarTarget.getAttribute('data-score');
        let shortage = this.shortageBarTarget.getAttribute('data-score');
        let total = parseInt(overdose, 10) + parseInt(shortage, 10);

        let overdoseBasis = total > 0 ? (overdose / total) * 100 : 50;

        this.overdoseBarTarget.style.flexBasis = overdoseBasis.toString() + '%';
        this.shortageBarTarget.style.flexBasis = (100 - overdoseBasis).toString() + '%';

        this.overdoseScoreTarget.innerHTML = overdose;
        this.shortageScoreTarget.innerHTML = shortage;
    }

    /**
     * Send request to add/remove overdose
     */
    overdose() {
        PostService.patchOverdose(RouteService.getParamsFromCurrentRoute('/posts/:id').id)
            .then(success => {
                let response = JSON.parse(success);
                this.overdoseBarTarget.setAttribute('data-score', response.overdose);
                this.shortageBarTarget.setAttribute('data-score', response.shortage);
                this.computeScore();
            })
            .catch(error => {
                console.log(error);
            });
    }

    /**
     * Send request to add/remove shortage
     */
    shortage() {
        PostService.patchShortage(RouteService.getParamsFromCurrentRoute('/posts/:id').id)
            .then(success => {
                let response = JSON.parse(success);
                this.overdoseBarTarget.setAttribute('data-score', response.overdose);
                this.shortageBarTarget.setAttribute('data-score', response.shortage);
                this.computeScore();
            })
            .catch(error => {
                console.log(error);
            });
    }
}
