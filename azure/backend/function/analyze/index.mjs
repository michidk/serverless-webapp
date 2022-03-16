// file name has to be 'index.mjs' in order to work with ECMAScript modules: https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference-node#ecmascript-modules
import main from "./main.js";

export default async function (context, req) {
    context.res = main(req.query);
};
