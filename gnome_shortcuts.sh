#!/bin/sh

set -ex

KEYS_GNOME_WM=/org/gnome/desktop/wm/keybindings
KEYS_GNOME_SHELL=/org/gnome/shell/keybindings

clear_keybindings() {
    # Disable switch to workspace by number shortcuts
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-1 "@as []"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-2 "@as []"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-3 "@as []"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-4 "@as []"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-5 "@as []"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-6 "@as []"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-7 "@as []"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-8 "@as []"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-9 "@as []"

    # Disable switch to application shortcuts that override 'Super+1, etc'
    dconf write ${KEYS_GNOME_SHELL}/switch-to-application-1 "@as []"
    dconf write ${KEYS_GNOME_SHELL}/switch-to-application-2 "@as []"
    dconf write ${KEYS_GNOME_SHELL}/switch-to-application-3 "@as []"
    dconf write ${KEYS_GNOME_SHELL}/switch-to-application-4 "@as []"
    dconf write ${KEYS_GNOME_SHELL}/switch-to-application-5 "@as []"
    dconf write ${KEYS_GNOME_SHELL}/switch-to-application-6 "@as []"
    dconf write ${KEYS_GNOME_SHELL}/switch-to-application-7 "@as []"
    dconf write ${KEYS_GNOME_SHELL}/switch-to-application-8 "@as []"
    dconf write ${KEYS_GNOME_SHELL}/switch-to-application-9 "@as []"

    # Clear the Move to workspace shortcuts
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-1 "@as []"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-2 "@as []"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-3 "@as []"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-4 "@as []"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-5 "@as []"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-6 "@as []"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-7 "@as []"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-8 "@as []"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-9 "@as []"
}

set_keybindings() {
    # Enable switch to workspace by number shortcuts
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-1 "@as ['<Super>1']"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-2 "@as ['<Super>2']"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-3 "@as ['<Super>3']"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-4 "@as ['<Super>4']"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-5 "@as ['<Super>5']"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-6 "@as ['<Super>6']"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-7 "@as ['<Super>7']"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-8 "@as ['<Super>8']"
    dconf write ${KEYS_GNOME_WM}/switch-to-workspace-9 "@as ['<Super>9']"

    # Enable move to workspace by number
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-1 "@as ['<Super><Shift>1']"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-2 "@as ['<Super><Shift>2']"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-3 "@as ['<Super><Shift>3']"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-4 "@as ['<Super><Shift>4']"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-5 "@as ['<Super><Shift>5']"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-6 "@as ['<Super><Shift>6']"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-7 "@as ['<Super><Shift>7']"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-8 "@as ['<Super><Shift>8']"
    dconf write ${KEYS_GNOME_WM}/move-to-workspace-9 "@as ['<Super><Shift>9']"

}

echo ' [+] Clearing existing keybindings'
clear_keybindings

echo ' [+] Setting better keybindings'
set_keybindings
