#! /bin/bash

# Overwrite parts of the omakub-menu with user-specific submenus.
# See $OMAKUB_PATH/bin/omakub-menu for functions that can be overwritten.
#
# WARNING: Overwritten functions will obviously not be updated when Omakub changes.
#
# Example of minimal system menu:
#
# show_system_menu() {
#   case $(menu "System" "  Lock\n󰐥  Shutdown") in
#   *Lock*) omakub-lock-screen ;;
#   *Shutdown*) omakub-cmd-shutdown ;;
#   *) back_to show_main_menu ;;
#   esac
# }

install_dotfiles_app() {
  present_terminal "echo 'Installing $1...'; dotfiles-app-install $1"
}

remove_dotfiles_app() {
  present_terminal "echo 'Removing $1...'; dotfiles-app-remove $1"
}

show_dotfiles_menu() {
  case $(menu "Dotfiles" "󰉉  Install\n󰭌  Remove\n  Setup\n󰑐  Update") in
  *Install*) show_dotfiles_install_menu ;;
  *Remove*) show_dotfiles_remove_menu ;;
  *Setup*) show_dotfiles_setup_menu ;;
  *Update*) show_dotfiles_update_menu ;;
  *) show_main_menu ;;
  esac
}

show_dotfiles_install_menu() {
  case $(menu "Install" "󰉉  Bruno\n  DBeaver\n  Filezilla") in
  *Bruno*) install_dotfiles_app "bruno" ;;
  *DBeaver*) install_dotfiles_app "dbeaver" ;;
  *Filezilla*) install_dotfiles_app "filezilla" ;;
  *) show_dotfiles_menu ;;
  esac
}

show_dotfiles_remove_menu() {
  case $(menu "Remove" "󰉉  Bruno\n  DBeaver\n  Filezilla") in
  *Bruno*) remove_dotfiles_app "bruno" ;;
  *DBeaver*) remove_dotfiles_app "dbeaver" ;;
  *Filezilla*) remove_dotfiles_app "filezilla" ;;
  *) show_dotfiles_menu ;;
  esac
}

show_dotfiles_setup_menu() {
  # Check if lid suspend is currently enabled
  if [ -f "$HOME/.local/state/dotfiles/toggles/lid-suspend" ]; then
    LID_SUSPEND_LABEL="  Disable Lid Suspend"
  else
    LID_SUSPEND_LABEL="  Enable Lid Suspend"
  fi

  case $(menu "Setup" "󱥸  Dotfiles\n$LID_SUSPEND_LABEL") in
  *Dotfiles*) open_in_editor "$HOME/.cfg/" ;;
  *Lid*) dotfiles-cmd-lid-closed-suspend ;;
  *) show_dotfiles_menu ;;
  esac
}

show_dotfiles_update_menu() {
  case $(menu "Update" "󰑐  Dotfiles\n  Config") in
  *Dotfiles*) present_terminal "dotfiles update" ;;
  *Config*) present_terminal dotfiles-refresh-config ;;
  *) show_dotfiles_menu ;;
  esac
}

show_main_menu() {
  go_to_menu "$(menu "Go" "󰀻  Apps\n󰧑  Learn\n󱓞  Trigger\n  Style\n  Setup\n󰉉  Install\n󰭌  Remove\n󰑐  Update\n  About\n󰤆  System\n󱥸  Dotfiles")"
}

go_to_menu() {
  case "${1,,}" in
  *apps*) omakub-apps ;;
  *learn*) show_learn_menu ;;
  *trigger*) show_trigger_menu ;;
  *style*) show_style_menu ;;
  *background*) show_background_menu ;;
  *theme*) show_theme_menu ;;
  *setup*) show_setup_menu ;;
  *install*) show_install_menu ;;
  *remove*) show_remove_menu ;;
  *update*) show_update_menu ;;
  *about*) omakub-launch-about ;;
  *system*) show_system_menu ;;
  *dotfiles*) show_dotfiles_menu ;;
  esac
}