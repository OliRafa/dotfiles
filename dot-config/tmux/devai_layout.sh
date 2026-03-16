#!/usr/bin/env bash

ai2="$1"
current_dir="$PWD"

# Get first pane (editor)
editor_pane=$(tmux display-message -p "#{pane_id}")

# Bottom shell pane (5 lines)
shell_pane=$(tmux split-window -v -p 5 -t "$editor_pane" -c "$current_dir" -P -F "#{pane_id}")

# Horizontal split → AI right
ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F "#{pane_id}")

# Optional second AI
if [[ -n "$ai2" ]]; then
  ai2_pane=$(tmux split-window -v -p 50 -t "$ai_pane" -c "$current_dir" -P -F "#{pane_id}")
  tmux send-keys -t "$ai2_pane" "$ai2" C-m
fi

# Run programs
tmux send-keys -t "$editor_pane" "devin" C-m
# tmux send-keys -t "$ai_pane" "devcode" C-m
tmux send-keys -t "$shell_pane" "devsh" C-m

# Focus editor
tmux select-pane -t "$editor_pane"
