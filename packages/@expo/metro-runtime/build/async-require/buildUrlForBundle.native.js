/**
 * Copyright © 2022 650 Industries.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
export function buildUrlForBundle(bundlePath) {
    if (process.env.NODE_ENV === 'production') {
        if (typeof location !== 'undefined') {
            return joinComponents(location.origin, bundlePath);
        }
        throw new Error('Unable to determine the production URL where additional JavaScript chunks are hosted because the global "location" variable is not defined.');
    }
    else {
        const getDevServer = require('../getDevServer')
            .default;
        const { url: serverUrl } = getDevServer();
        return joinComponents(serverUrl, bundlePath);
    }
}
function joinComponents(prefix, suffix) {
    return prefix.replace(/\/+$/, '') + '/' + suffix.replace(/^\/+/, '');
}
//# sourceMappingURL=buildUrlForBundle.native.js.map