export function respond(status, headers, body, res = null) {
    for (const [key, value] of Object.entries(headers)) {
        res.set(key, value);
    }
    return res.status(status).send(body);
}
