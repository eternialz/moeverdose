import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';
import { PostService } from '../../../services/post-service';
import { RouteService } from '../../../services/route-service';

@RegisterController
class PostShowController extends Controller {
    addFavorite() {
        PostService.patchFavorite(RouteService.getParamsFromCurrentRoute('/posts/:id').id)
            .then(success => {
                console.log(success);
            })
            .catch(error => {
                console.log(error);
            });
    }
}
