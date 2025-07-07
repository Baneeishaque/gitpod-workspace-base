#!/bin/bash

# Color and style definitions
BOLD=$(tput bold)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
RED=$(tput setaf 1)
RESET=$(tput sgr0)
CHECK="${GREEN}✓${RESET}"
CROSS="${RED}✗${RESET}"
ARROW="${BLUE}➜${RESET}"

# Configuration
BASE_DIR="$HOME/.local"
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BASE_DIR" "$BIN_DIR"

# Header
echo "${BOLD}${BLUE}=== Chrome Headless Shell & Chromedriver Installer ===${RESET}"
echo "This will install components to: ${YELLOW}${BASE_DIR}${RESET}"
echo ""

# Function for visual steps
run_step() {
    local step_msg="$1"
    local cmd="$2"
    
    echo "${BOLD}${YELLOW}• ${step_msg}...${RESET}"
    if eval "$cmd" >/dev/null 2>&1; then
        echo "  ${CHECK} Success"
        return 0
    else
        echo "  ${CROSS} Failed"
        return 1
    fi
}

# Installation Steps
echo "${BOLD}Installation Steps:${RESET}"

run_step "Installing Chrome Headless Shell" \
    "yes | npx @puppeteer/browsers install chrome-headless-shell@stable --path '$BASE_DIR'" || exit 1

run_step "Locating Chrome binary" \
    "CHROME_BIN=\$(find '$BASE_DIR'/chrome-headless-shell/linux-*/chrome-headless-shell-linux64 -name 'chrome-headless-shell' -type f | head -1)" || exit 1

run_step "Creating symlinks (chrome-headless-shell, chrome, google-chrome)" \
    "ln -sf '$CHROME_BIN' '$BIN_DIR/chrome-headless-shell' && \
     ln -sf '$CHROME_BIN' '$BIN_DIR/chrome' && \
     ln -sf '$CHROME_BIN' '$BIN_DIR/google-chrome'" || exit 1

run_step "Installing Chromedriver" \
    "yes | npx @puppeteer/browsers install chromedriver@stable --path '$BASE_DIR'" || exit 1

run_step "Creating chromedriver symlink" \
    "ln -sf \$(find '$BASE_DIR'/chromedriver/linux-*/chromedriver-linux64 -name 'chromedriver' -type f | head -1) '$BIN_DIR/chromedriver'" || exit 1

# PATH configuration
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "${YELLOW}• Adding to PATH...${RESET}"
    echo "export PATH=\"\$PATH:$BIN_DIR\"" >> ~/.bashrc
    source ~/.bashrc
    echo "  ${CHECK} ${BIN_DIR} added to your PATH"
fi

# Final Output
echo ""
echo "${BOLD}${GREEN}Installation Complete!${RESET}"
echo ""
echo "${BOLD}Installed Components:${RESET}"

# Improved version checking
get_version() {
    local cmd="$1"
    local version=$($cmd --version 2>/dev/null)
    if [ -z "$version" ]; then
        echo "Not found"
    else
        echo "$version"
    fi
}

echo "${ARROW} ${BOLD}Chrome Headless Shell:${RESET} $(get_version "$BIN_DIR/chrome-headless-shell")"
echo "${ARROW} ${BOLD}Chrome (Symlink):${RESET} $(get_version "$BIN_DIR/chrome")"
echo "${ARROW} ${BOLD}Google Chrome (Symlink):${RESET} $(get_version "$BIN_DIR/google-chrome")"
echo "${ARROW} ${BOLD}Chromedriver:${RESET} $(get_version "$BIN_DIR/chromedriver")"
echo ""
echo "${BOLD}Available Commands:${RESET}"
echo "  ${ARROW} chrome-headless-shell"
echo "  ${ARROW} chrome"
echo "  ${ARROW} google-chrome"
echo "  ${ARROW} chromedriver"
echo ""
echo "${BOLD}Next Steps:${RESET}"
echo "1. Try running: ${YELLOW}chrome-headless-shell --version${RESET}"
echo "2. For automated testing, use: ${YELLOW}chromedriver${RESET}"
echo ""
echo "${BOLD}Installation Directory:${RESET} ${YELLOW}${BASE_DIR}${RESET}"
echo "${BOLD}Symlinks Directory:${RESET} ${YELLOW}${BIN_DIR}${RESET}"
