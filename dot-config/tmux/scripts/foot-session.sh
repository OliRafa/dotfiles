#!/bin/bash
# Foot launches this instead of a bare shell (see ~/.config/foot/foot.ini).
#
# It starts a fresh tmux session and marks that session destroy-unattached, so
# closing the foot window (which detaches its client) destroys the session
# instead of leaving it around detached. The option is set without -g, so it is
# scoped to this one session only: the named sessions devai/tdl create detached
# are global-off and unaffected.
exec tmux new-session \; set-option destroy-unattached on
