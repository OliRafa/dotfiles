#!/usr/bin/env sh
# Minimize/restore tmux panes via a hidden holding window named "_min",
# remembering each pane's origin window and layout so restore is exact.
#
#   pane-min.sh minimize [pane-id]   hide the pane in the _min window
#   pane-min.sh restore  <pane-id>   rejoin the pane at its original position
#   pane-min.sh has                  exit 0 if a _min window exists (for if-shell)
#
# The origin window + full window layout are stashed on the pane itself as
# @min_owin / @min_layout user options (they travel with the pane). On restore
# the pane is joined back into its origin window and the saved layout is
# re-applied, which reproduces its exact former position and size.
#
# Logic lives in a script (not inline in tmux.conf) so the inner `tmux` format
# strings are NOT mangled by tmux's run-shell/if-shell format expansion.
set -eu

win=_min
cmd="${1:-}"
pane="${2:-}"

# Resolve the session the pane (or current client) lives in.
if [ -n "$pane" ]; then
  sess=$(tmux display-message -p -t "$pane" '#{session_name}')
else
  sess=$(tmux display-message -p '#{session_name}')
fi

has_min() {
  tmux list-windows -t "$sess" -F '#{window_name}' | grep -qx "$win"
}

case "$cmd" in
  minimize)
    [ -n "$pane" ] || pane=$(tmux display-message -p '#{pane_id}')
    # Remember where this pane lived and the exact layout it was part of.
    owin=$(tmux display-message -p -t "$pane" '#{window_id}')
    olayout=$(tmux display-message -p -t "$pane" '#{window_layout}')
    tmux set-option -p -t "$pane" @min_owin "$owin"
    tmux set-option -p -t "$pane" @min_layout "$olayout"
    if has_min; then
      tmux join-pane -d -s "$pane" -t "$sess:$win"
    else
      tmux break-pane -d -s "$pane" -n "$win"
    fi
    ;;
  restore)
    [ -n "$pane" ] || exit 2
    owin=$(tmux show-options -p -t "$pane" -v @min_owin 2>/dev/null || true)
    olayout=$(tmux show-options -p -t "$pane" -v @min_layout 2>/dev/null || true)
    if [ -n "$owin" ] && tmux display-message -p -t "$owin" '#{window_id}' >/dev/null 2>&1; then
      # Rejoin into the origin window (lands at the end of the pane order).
      tmux join-pane -s "$pane" -t "$owin"
      # Reproduce the exact original layout. select-layout maps panes to cells by
      # the window's pane ORDER (not by the pane ids in the string), so first
      # reorder panes into the layout's cell order, then apply it. Only attempt
      # this once every pane from that layout is back (counts match), otherwise
      # leave the pane where join-pane put it.
      if [ -n "$olayout" ]; then
        leaves=$(printf '%s' "$olayout" | grep -oE '[0-9]+x[0-9]+,[0-9]+,[0-9]+,[0-9]+' | awk -F, '{print $NF}')
        nleaf=$(printf '%s\n' "$leaves" | grep -c . || true)
        npane=$(tmux display-message -p -t "$owin" '#{window_panes}')
        if [ "$nleaf" = "$npane" ]; then
          base=$(tmux show-options -gv pane-base-index 2>/dev/null || echo 0)
          k=0
          for id in $leaves; do
            idx=$((k + base))
            cur=$(tmux display-message -p -t "${owin}.${idx}" '#{pane_id}')
            [ "$cur" = "%$id" ] || tmux swap-pane -s "%$id" -t "${owin}.${idx}"
            k=$((k + 1))
          done
          tmux select-layout -t "$owin" "$olayout"
        fi
      fi
    else
      tmux join-pane -s "$pane"
    fi
    tmux set-option -pu -t "$pane" @min_owin 2>/dev/null || true
    tmux set-option -pu -t "$pane" @min_layout 2>/dev/null || true
    ;;
  has)
    has_min
    ;;
  *)
    echo "usage: pane-min.sh {minimize [pane-id]|restore <pane-id>|has}" >&2
    exit 2
    ;;
esac
