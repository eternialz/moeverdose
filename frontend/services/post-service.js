import { HttpService } from './http-service';

export const PostService = {
    patchOverdose: function(post_id) {
        return HttpService.makeRequest({
            method: 'PATCH',
            url: `/posts/${post_id}/dose/overdose`,
        });
    },
    patchShortage: function(post_id) {
        return HttpService.makeRequest({
            method: 'PATCH',
            url: `/posts/${post_id}/dose/shortage`,
        });
    },
    patchFavorite: function(post_id) {
        return HttpService.makeRequest({
            method: 'PATCH',
            url: `/posts/${post_id}/favorite`,
        });
    },
};
