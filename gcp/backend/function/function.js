import main from "./main.js";

export async function handler(req, res) {
    return main(req.query, res);
};
