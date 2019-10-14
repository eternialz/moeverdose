import { RegisterController } from '../../../decorators/register_controller_decorator';
import { Controller } from 'stimulus';
import { PostService } from '../../../services/post-service';
import { RouteService } from '../../../services/route-service';
import { LightboxService } from '../../../services/lightbox-service';

@RegisterController
class PostShowController extends Controller {
    static targets = ['report', 'image', 'unfavorite', 'favorite'];

    addFavorite() {
        PostService.patchFavorite(RouteService.getParamsFromCurrentRoute('/posts/:id').id)
            .then(success => {
                this.favoriteTarget.classList.toggle('hidden');
                this.unfavoriteTarget.classList.toggle('hidden');
            })
            .catch(error => {
                console.error(error);
            });
    }

    showReport() {
        this.reportTarget.remove();
        this.imageTarget.classList.remove('post-show-image-reported');
    }

    showLightbox() {
        LightboxService.toggle();
    }
}
