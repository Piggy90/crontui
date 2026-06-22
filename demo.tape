# VHS Tape File
# Record gorgeous terminal animations.
# Run: vhs < demo.tape

Output demo.gif

Require crontui

Set Shell "bash"
Set FontSize 18
Set FontFamily "DejaVu Sans Mono"
Set Width 1200
Set Height 850
Set Theme "Chalk"
Set Padding 30
Set LetterSpacing 0

# Clean startup
Type "clear"
Enter
Sleep 0.5s

# Start CronTUI
Type "crontui"
Enter
Sleep 2s

# 1. View Active Cronjobs (option 1)
Type "1"
Sleep 3s
Enter
Sleep 1s

# 2. Run Healthcheck (option 7)
Type "7"
Sleep 3.5s
Enter
Sleep 1s

# 3. Open Week Timeline (option 8)
Type "8"
Sleep 4.5s
Enter
Sleep 1s

# 4. Open Day Zoom view (option 9)
Type "9"
Sleep 4.5s
Enter
Sleep 1s

# 5. Open Month Heatmap (option m)
Type "m"
Sleep 4s
Enter
Sleep 1s

# 6. Open Year Heatmap (option j)
Type "j"
Sleep 4.5s
Enter
Sleep 1s

# Exit TUI
Type "0"
Sleep 1.5s

# End pause for smooth GIF loop
Sleep 2s
