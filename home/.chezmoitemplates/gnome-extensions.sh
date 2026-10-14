# Helpers for GNOME Shell extensions, shared by the GNOME scripts.

ext_dir() {
  for dir in "${XDG_DATA_HOME:-$HOME/.local/share}/gnome-shell/extensions/$1" "/usr/share/gnome-shell/extensions/$1"; do
    if [ -f "$dir/metadata.json" ]; then
      printf '%s\n' "$dir"
      return 0
    fi
  done
  return 1
}

ext_installed() {
  ext_dir "$1" >/dev/null
}

# ext_listed <enabled-extensions|disabled-extensions> <uuid>
ext_listed() {
  case "$(gsettings get org.gnome.shell "$1")" in
    *"'$2'"*) return 0 ;;
  esac
  return 1
}

ext_enabled() {
  if ! ext_installed "$1"; then
    return 1
  fi
  if [ "$(gsettings get org.gnome.shell disable-user-extensions)" = true ]; then
    return 1
  fi
  if ! ext_listed enabled-extensions "$1"; then
    return 1
  fi
  if ext_listed disabled-extensions "$1"; then
    return 1
  fi
  return 0
}

ext_list_add() {
  if ext_listed "$1" "$2"; then
    return 0
  fi
  current=$(gsettings get org.gnome.shell "$1")
  case "$current" in
    '[]'|'@as []') gsettings set org.gnome.shell "$1" "['$2']" ;;
    *) gsettings set org.gnome.shell "$1" "${current%]}, '$2']" ;;
  esac
}

ext_list_remove() {
  if ! ext_listed "$1" "$2"; then
    return 0
  fi
  pattern=$(printf '%s' "$2" | sed 's/[][\.*^$/]/\\&/g')
  gsettings set org.gnome.shell "$1" "$(gsettings get org.gnome.shell "$1" |
    sed -e "s/'$pattern', //" -e "s/, '$pattern'//" -e "s/'$pattern'//" -e 's/^@as //')"
}

# ext_set <uuid> <schema> <key> <value>
ext_set() {
  gsettings --schemadir "$(ext_dir "$1")/schemas" set "$2" "$3" "$4"
}

# True when the running GNOME Shell is reachable on the session bus.
shell_session() {
  command -v gdbus >/dev/null 2>&1 &&
    gdbus introspect --session --dest org.gnome.Shell.Extensions \
      --object-path /org/gnome/Shell/Extensions >/dev/null 2>&1
}
