#!/bin/sh
# Rex session picker: fzf over the server's sessions, inside a floating pane.
#   enter  open the highlighted session
#   x      kill the highlighted session (after confirmation)
#   type   filter; a name that matches nothing offers to create it
# Called by the session_picker action in init.lua:
#   session-picker.sh <session_id> <layer_id>

session=$1
layer=$2

rex=${REX_CLI:-}
if [ -z "$rex" ] && [ -n "${REX_BIN_DIR:-}" ]; then
  rex="$REX_BIN_DIR/rex"
fi
[ -z "$rex" ] && rex=rex

close_layer() {
  [ -n "$session" ] && [ -n "$layer" ] || return 0
  "$rex" api call -s "$session" session.close_layer \
    "{\"session_id\":\"$session\",\"layer_id\":\"$layer\"}" >/dev/null 2>&1
}
trap close_layer EXIT INT TERM

list_sessions() {
  "$rex" api call -s "$session" session.list 2>/dev/null |
    jq -r '.sessions[] | "\(.label)\t\(.session_id)"'
}

confirm() {
  printf '\n%s [y/N] ' "$1"
  read -r answer
  case "$answer" in
    y | Y | yes | YES) return 0 ;;
  esac
  return 1
}

# TokyoNight (Night), overriding the Dracula colors in FZF_DEFAULT_OPTS.
colors="--color=fg:#c0caf5,bg:#1a1b26,hl:#7aa2f7
--color=fg+:#c0caf5,bg+:#33467c,hl+:#7dcfff
--color=info:#e0af68,prompt:#9ece6a,pointer:#bb9af7
--color=marker:#f7768e,spinner:#e0af68,header:#7aa2f7,query:#c0caf5"

target=
rows=$(list_sessions)

while [ -n "$rows" ]; do
  # shellcheck disable=SC2086
  out=$(printf '%s\n' "$rows" | fzf \
    --delimiter='\t' --with-nth=1 --no-multi --reverse --cycle \
    --preview-window=hidden --print-query --expect=x \
    --bind 'j:down,k:up' \
    $colors \
    --prompt='session> ' \
    --header='j/k move · enter open · x kill · new name + enter creates · esc cancel')
  status=$?
  [ "$status" -eq 130 ] && break

  query=$(printf '%s\n' "$out" | sed -n '1p')
  key=$(printf '%s\n' "$out" | sed -n '2p')
  selected=$(printf '%s\n' "$out" | sed -n '3p')

  if [ "$key" = "x" ]; then
    [ -z "$selected" ] && continue
    name=$(printf '%s' "$selected" | cut -f1)
    id=$(printf '%s' "$selected" | cut -f2)
    if [ "$id" = "$session" ]; then
      confirm "Kill the session this picker runs in? Every pane in it closes." || continue
    else
      confirm "Kill session \"$name\"? Every pane in it closes." || continue
    fi
    "$rex" api call session.destroy "{\"session_id\":\"$id\"}" >/dev/null 2>&1
    rows=$(list_sessions)
    continue
  fi

  if [ -n "$selected" ]; then
    target=$(printf '%s' "$selected" | cut -f2)
    break
  fi

  name=$(printf '%s' "$query" | sed 's/^ *//; s/ *$//')
  [ -z "$name" ] && break
  confirm "No session matches \"$name\". Create it?" || continue

  created=$("$rex" api call session.create "$(jq -n --arg n "$name" '{
    label: $n,
    initial_windows: [{
      layout: {
        split: {
          direction: "vertical",
          ratio: 0.8,
          before: { block: { flavor: "com.superlogical.terminal.shell" } },
          after: { block: { flavor: "com.superlogical.terminal.shell" } }
        }
      }
    }]
  }')" 2>/dev/null)
  target=$(printf '%s' "$created" | jq -r '.session_id // empty')
  break
done

[ -z "$target" ] && exit 0

# session.select is a client action, so it needs the app's label.
label=$("$rex" api call client.list 2>/dev/null |
  jq -r '[.clients[] | select(.info.kind == "app") | .info.label][0] // empty')
[ -z "$label" ] && exit 0

"$rex" -C "$label" do session.select session_id="$target" >/dev/null 2>&1
