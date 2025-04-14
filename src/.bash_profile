#!/usr/bin/env bash
# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.pre.bash"

. ~/.bashrc

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/yuichi.hasegawa/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.post.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.post.bash"
