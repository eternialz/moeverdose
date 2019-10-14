export const RouteService = {
    getParamsFromCurrentRoute: function(routePattern) {
        return this.getParamsFromRoute(routePattern, window.location.pathname);
    },
    getParamsFromRoute: function(routePattern, route) {
        let patterns = [];
        routePattern.split('/').forEach((r, index) => {
            if (r[0] === ':') {
                patterns.push({
                    index: index,
                    value: r.slice(1),
                });
            }
        });

        let params = {};
        let paths = route.split('/');

        patterns.forEach(p => {
            params[p.value] = paths[p.index];
        });

        return params;
    },
    currentRouteMatch: function(regexp) {
        return window.location.pathname.match(regexp);
    },
};
