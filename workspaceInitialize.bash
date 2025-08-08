source bash_scripts/gitpod_related_scripts/workspaceInitialize.bash
source bash_scripts/installPowerShell.bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" &&
# echo "SCRIPT_DIR: $SCRIPT_DIR" &&
initialize_workspace &&
echo "This is post_initialize from ${BASH_SOURCE[0]}" &&
cd "$SCRIPT_DIR" &&
# pwd
install_power_shell &&
. "$SCRIPT_DIR/bash_scripts/installHadoLint.bash"
