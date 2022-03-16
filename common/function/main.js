import { respond } from "./abstraction.js";
import { analyze } from "./analyzer.js";

export default function main(parameters, res = null) {
    let result = {};
    if (parameters != null && "input" in parameters) {
        let input = Buffer.from(parameters["input"], 'base64').toString('utf-8');

        result = analyze(input);
    }

    if ("success" in result && result.success) {
        return respond(200, {
            'content-type': 'application/json; charset=utf-8',
        }, result.data, res);
    } else {
        return respond(500, {
            'content-type': 'application/json; charset=utf-8',
        },
            JSON.stringify({
                error: "Something went wrong."
            }), res)
    }
}
