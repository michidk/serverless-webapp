apply target:
    cd {{justfile_directory()}}/{{target}} && terraform apply

apply-y target:
    cd {{justfile_directory()}}/{{target}} && terraform apply -auto-approve

fmt:
    cd {{justfile_directory()}}/aws && terraform fmt
    cd {{justfile_directory()}}/azure && terraform fmt
    cd {{justfile_directory()}}/gcp && terraform fmt

clean:
    #!/usr/bin/env sh
    rm {{justfile_directory()}}/gcp/backend/function/analyzer.js 2> /dev/null
    rm {{justfile_directory()}}/gcp/backend/function/main.js 2> /dev/null
    rm {{justfile_directory()}}/gcp/backend/function/package.json 2> /dev/null
    rm {{justfile_directory()}}/aws/backend/function/analyzer.js 2> /dev/null
    rm {{justfile_directory()}}/aws/backend/function/main.js 2> /dev/null
    rm {{justfile_directory()}}/aws/backend/function/package.json 2> /dev/null
    rm {{justfile_directory()}}/azure/backend/function/analyzer/analyzer.js 2> /dev/null
    rm {{justfile_directory()}}/azure/backend/function/analyzer/main.js 2> /dev/null
    rm {{justfile_directory()}}/azure/backend/function/package.json 2> /dev/null
