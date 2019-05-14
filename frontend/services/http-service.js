import { NotificationService } from './notification-service';

// https://stackoverflow.com/questions/30008114/how-do-i-promisify-native-xhr/30008115#30008115
export const HttpService = {
    /**
     * Return CSRF token for rails session
     */
    token: function() {
        return document.querySelector('meta[name="csrf-token"]').content;
    },
    /**
     * Request wrapper to display notifications
     */
    makeRequest: function(opts) {
        return new Promise(function(resolve, reject) {
            let request = HttpService.executeRequest(opts);

            // Intercept response to display notification if message and type are present
            Promise.all([request]).then(values => {
                let response = JSON.parse(values[0]);
                let message = response.message;
                let type = response.type;

                // Display a notification if both type and message are present
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
    /**
     * XHR request manager
     */
    executeRequest: function(opts) {
        return new Promise(function(resolve, reject) {
            var xhr = new XMLHttpRequest();
            xhr.open(opts.method, opts.url);

            xhr.onload = function() {
                if (this.status >= 200 && this.status < 300) {
                    // Send response on success
                    resolve(xhr.response);
                } else if (this.status >= 300 && this.status < 400) {
                    // Redirect if url specified in response header, else reject
                    let redirect_url = this.getResponseHeader('X-Xhr-Redirect-Url');
                    if (redirect_url != undefined) {
                        window.location.pathname = redirect_url;
                    } else {
                        reject({
                            status: this.status,
                            statusText: xhr.statusText,
                        });
                    }
                } else {
                    // Reject on request responding with errors (400 to 599)
                    reject({
                        status: this.status,
                        statusText: xhr.statusText,
                    });
                }
            };

            // Callback on request error
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

            // Set default necessary request header
            xhr.setRequestHeader('X-CSRF-Token', HttpService.token());

            // Stringify params if object
            var params = opts.params;
            if (params && typeof params === 'object') {
                params = Object.keys(params)
                    .map(function(key) {
                        return encodeURIComponent(key) + '=' + encodeURIComponent(params[key]);
                    })
                    .join('&');
            }

            // Send request with params
            xhr.send(params);
        });
    },
};
