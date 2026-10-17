#!/bin/bash
success=0
failure=0
for dir in aws/base_component/*/ aws/workload_component/*/; do
    echo "Validating $dir"
    cd "$dir"
    terraform init -backend=false > /dev/null 2>&1
    if terraform validate > /dev/null 2>&1; then
        echo "✅ $dir"
        ((success++))
    else
        echo "❌ $dir"
        terraform validate # show error
        ((failure++))
    fi
    cd - > /dev/null
done
echo "Success: $success, Failure: $failure"
if [ $failure -gt 0 ]; then exit 1; fi
