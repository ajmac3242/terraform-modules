import os
import re

def fix_eventbridge_interpolation():
    path = "aws/base_component/eventbridge/main.tf"
    if not os.path.exists(path): return
    with open(path, 'r') as f:
        content = f.read()

    # Use coalesce(var.name, "default")
    # Fixed interpolation error: Cannot include a null value in a string template.
    new_content = content.replace('${var.name}', '${coalesce(var.name, "default")}')
    if new_content != content:
        with open(path, 'w') as f:
            f.write(new_content)
        print(f"Fixed {path}")

def fix_account_security_unused_region():
    path = 'aws/base_component/account_security/main.tf'
    if not os.path.exists(path): return
    with open(path, 'r') as f:
        content = f.read()
    new_content = content.replace('data "aws_region" "current" {}', '')
    if new_content != content:
        with open(path, 'w') as f:
            f.write(new_content)
        print(f"Removed unused region from {path}")

def fix_securityhub_unused_var():
    path = 'aws/base_component/securityhub/variables.tf'
    if not os.path.exists(path): return
    with open(path, 'r') as f:
        content = f.read()
    new_content = re.sub(r'variable\s+"finding_aggregation_region"\s+\{.*?\}', '', content, flags=re.DOTALL)
    if new_content != content:
        with open(path, 'w') as f:
            f.write(new_content)
        print(f"Removed unused var from {path}")

def fix_alb_ecs_fargate_unused_region():
    path = 'aws/workload_component/alb_ecs_fargate/main.tf'
    if not os.path.exists(path): return
    with open(path, 'r') as f:
        content = f.read()
    new_content = content.replace('region     = data.aws_region.current.id', '')
    if new_content != content:
        with open(path, 'w') as f:
            f.write(new_content)
        print(f"Removed unused region from {path}")

fix_eventbridge_interpolation()
fix_account_security_unused_region()
fix_securityhub_unused_var()
fix_alb_ecs_fargate_unused_region()
