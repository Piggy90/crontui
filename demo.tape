# VHS Tape File
# Record gorgeous terminal animations.
# Install VHS: brew install vhs (or apt install vhs)
# Run: vhs < demo.tape

Output demo.gif

Require crontui

Set Shell "bash"
Set FontSize 14
Set FontFamily "DejaVu Sans Mono"
Set Width 900
Set Height 650
Set Theme "Charm"
Set Padding 20
Set LetterSpacing 0

# Start CronTUI
Type "crontui"
Enter
Sleep 2s

# Open Week Timeline (option 8)
Type "8"
Sleep 4s
Enter
Sleep 1s

# Open Month Heatmap (option m)
Type "m"
Sleep 1.5s
# Enter month (e.g. June/Juni)
Type "June"
Enter
Sleep 4s
Enter
Sleep 1s

# Open Year Heatmap (option j)
Type "j"
Sleep 5s
Enter
Sleep 1s

# Exit TUI
Type "0"
Sleep 1.5s
