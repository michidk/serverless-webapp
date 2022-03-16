import main from "./main.js";

export async function handler(event, context) {
    return main(event.queryStringParameters);
};
