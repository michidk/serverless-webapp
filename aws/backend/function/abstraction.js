export function respond(status, headers, body, res) {
    return {
        statusCode: status,
        headers,
        body,
    };
}
