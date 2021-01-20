url(){
  cat <<EOF | osascript 
tell application "Google Chrome" to return URL of active tab of front window
EOF
}


split3(){
  cat <<EOF | osascript
tell application "iTerm"
    activate

    set W to current window
    if W = missing value then set W to create window with default profile
    tell W's current session
        split vertically with default profile
        split vertically with default profile
    end tell
    set T to W's current tab
    write T's session 1 text "cd ~/Desktop"
    write T's session 2 text "cd ~/Downloads"
    write T's session 3 text "cd ~/Documents"
end tell
EOF
}
