import os
import re

def fix_ecs_fargate():
    main_path = "aws/base_component/ecs_fargate/main.tf"
    if os.path.exists(main_path):
        with open(main_path, 'r') as f: content = f.read()
        content = content.replace('data "aws_region" "current" {}', '')
        # it was used in logConfiguration
        content = content.replace('\"awslogs-region\"        = data.aws_region.current.name', '\"awslogs-region\"        = data.aws_region.current.name # ERROR')
        with open(main_path, 'w') as f: f.write(content)
    # wait, if I remove it, I must fix the usage.
    # Actually, data.aws_region.current is useful. tflint warns if it's NOT used.
    # My script said it's unused. Let's see.

def fix_kms():
    vars_path = "aws/base_component/kms/variables.tf"
    if os.path.exists(vars_path):
        with open(vars_path, 'r') as f: content = f.read()
        content = re.sub(r'variable "aws_account_id" {[^}]*}', '', content, flags=re.MULTILINE | re.DOTALL)
        with open(vars_path, 'w') as f: f.write(content)

# Just run the global cleanup again, it's safer.
