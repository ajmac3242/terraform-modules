import os
import re

path = "aws/base_component/ecs_fargate/main.tf"
with open(path, 'r') as f:
    content = f.read()

# I might have accidentally removed too much
# Let's restore the basic structure if broken

def fix_module_call(content, module_name):
    # Match module "name" { ... }
    pattern = r'module\s+"' + module_name + r'"\s+\{(?:[^{}]|\{[^{}]*\})*\}'
    match = re.search(pattern, content, re.DOTALL)
    if match:
        block = match.group(0)
        # Check for role_arn usage in task definition
        # execution_role_arn       = module.task_execution_role.role_arn
        # task_role_arn            = module.task_role.role_arn
        return True
    return False

print(f"task_execution_role present: {fix_module_call(content, 'task_execution_role')}")
print(f"task_role present: {fix_module_call(content, 'task_role')}")
