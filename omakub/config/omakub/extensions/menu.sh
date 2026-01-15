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
  case $(menu "Dotfiles" "󰉉  Install\n󰭌  Remove\n  Setup" "--width 250 --height 170") in
  *Install*) show_dotfiles_install_menu ;;
  *Remove*) show_dotfiles_remove_menu ;;
  *Setup*) show_dotfiles_setup_menu ;;
  *) show_main_menu ;;
  esac
}

show_dotfiles_install_menu() {
  case $(menu "Install" "󰉉  Bruno\n  DBeaver\n  Filezilla" "--width 250 --height 170") in
  *Bruno*) install_dotfiles_app "bruno" ;;
  *DBeaver*) install_dotfiles_app "dbeaver" ;;
  *Filezilla*) install_dotfiles_app "filezilla" ;;
  *) show_dotfiles_menu ;;
  esac
}

show_dotfiles_remove_menu() {
  case $(menu "Remove" "󰉉  Bruno\n  DBeaver\n  Filezilla" "--width 250 --height 170") in
  *Bruno*) remove_dotfiles_app "bruno" ;;
  *DBeaver*) remove_dotfiles_app "dbeaver" ;;
  *Filezilla*) remove_dotfiles_app "filezilla" ;;
  *) show_dotfiles_menu ;;
  esac
}

show_dotfiles_setup_menu() {
  case $(menu "Setup" "󱥸  Dotfiles\n  Lid Suspend" "--width 250 --height 130") in
  *Dotfiles*) open_in_editor "$HOME/.cfg/" ;;
  *Lid*) dotfiles-cmd-lid-suspend ;;
  *) show_dotfiles_menu ;;
  esac
}

show_main_menu() {
  go_to_menu "$(menu "Go" "󰀻  Apps\n󰧑  Learn\n󱓞  Trigger\n  Style\n  Setup\n󰉉  Install\n󰭌  Remove\n  Update\n  About\n  System\n󱥸  Dotfiles" "--width 250 --height 470")"
}

go_to_menu() {
  case "${1,,}" in
  *apps*) omakub-apps ;;
  *learn*) show_learn_menu ;;
  *trigger*) show_trigger_menu ;;
  *style*) show_style_menu ;;
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