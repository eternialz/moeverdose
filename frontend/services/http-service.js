import { NotificationService } from './notification-service';

// https://stackoverflow.com/questions/30008114/how-do-i-promisify-native-xhr/30008115#30008115
export const HttpService = {
    token: function() {
        return document.querySelector('meta[name="csrf-token"]').content;
    },
    makeRequest: function(opts) {
        return new Promise(function(resolve, reject) {
            let request = HttpService.executeRequest(opts);

            // Intercept response to display notification if message and type are present
            Promise.all([request]).then(values => {
                let response = JSON.parse(values[0]);
                let message = response.message;
                let type = response.type;

                if (message && type) {
                    NotificationService.newNotification(message, type);
                }
            });

            // Continue execution
            request.then(success => resolve(success));
            request.catch(error => reject(error));
            return;
        });
    },
    executeRequest: function(opts) {
        return new Promise(function(resolve, reject) {
            var xhr = new XMLHttpRequest();
            xhr.open(opts.method, opts.url);
            xhr.setRequestHeader('X-CSRF-Token', HttpService.token());
            xhr.setRequestHeader('Content-Type', 'application/html');
            xhr.onload = function() {
                if (this.status >= 200 && this.status < 300) {
                    resolve(xhr.response);
                } else if (this.status >= 300 && this.status < 400) {
                    let redirect_url = this.getResponseHeader('X-Xhr-Redirect-Url');
                    if (redirect_url != undefined) {
                        window.location.pathname = redirect_url;
                    }
                } else {
                    reject({
                        status: this.status,
                        statusText: xhr.statusText,
                    });
                }
            };
            xhr.onerror = function() {
                reject({
                    status: this.status,
                    statusText: xhr.statusText,
                });
            };
            if (opts.headers) {
                Object.keys(opts.headers).forEach(function(key) {
                    xhr.setRequestHeader(key, opts.headers[key]);
                });
            }
            var params = opts.params;
            // We'll need to stringify if we've been given an object
            // If we have a string, this is skipped.
            if (params && typeof params === 'object') {
                params = Object.keys(params)
                    .map(function(key) {
                        return encodeURIComponent(key) + '=' + encodeURIComponent(params[key]);
                    })
                    .join('&');
            }
            xhr.send(params);
        });
    },
};
