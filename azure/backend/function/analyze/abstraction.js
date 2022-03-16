export function respond(status, headers, body) {
    return {
        status,
        headers,
        body,
    };
}
