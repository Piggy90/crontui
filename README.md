# CronTUI ⏰📊

A beautiful, dependency-free terminal-based visualizer and manager for your cronjobs.

`CronTUI` is a standalone, lightweight Bash utility that transforms the standard, dry crontab management experience into an interactive, color-coded visual agenda. It lets you analyze your cron scheduling patterns over days, weeks, months, and years in a clean TUI heatmap—helping you identify execution overlap and schedule conflicts instantly.

---

## 🌟 Features

- 📂 **Safe Cron Management**: View active cronjobs, add new ones with validation, and safely remove them by index.
- ⚡ **On-Demand Testing**: Run any cronjob command manually in a sandbox environment right from the CLI.
- 📆 **Week Timeline**: View a horizontal hour-by-hour weekly grid mapping when tasks are scheduled.
- 🔍 **Day Zoom View**: Drill down into a specific day to see a 60-minute horizontal timeline showing exactly which minute a job runs, complete with job command labels.
- 📅 **Month Heatmap**: Visual month-calendar heatmap representing job density per day.
- 🗺️ **Year Heatmap**: A stunning 3x4 grid rendering of all 12 months with day-by-day job density heatmaps.
- 🏥 **Health & Logs**: Easily check service status (cron/crond), task count, view syslogs via `journalctl`, and view custom task logs if available.
- 🪶 **Dependency-Free**: 100% self-contained Bash script with embedded Python helper routines. No `npm`, `pip`, or packaging tools required. Works out of the box on any Unix system with Python 3.

---

## 📸 Visual Previews

### Week Timeline
```text
==========================================
           CRON WEEK TIMELINE             
==========================================
Hours 0 to 23 (columns left to right):
0         6         12        18        23
|         |         |         |         |

Mon  ■■.■■.■.■■..■.....■.....  (10 jobs)
Tue  ■■.■■.■.■■..■.....■.....  (10 jobs)
Wed  ■■.■■.■.■■..■.....■.....  (10 jobs)
Thu  ■■.■■.■.■■..■.....■.....  (10 jobs)
Fri  ■■.■■.■.■■..■.....■.....  (10 jobs)
Sat  ■■.■■.■.■■..■.....■.....  (10 jobs)
Sun  ■■.■■.■.■■..■.....■.....  (12 jobs)
```

### Day Zoom View
```text
==========================================
     CRON ZOOM VIEW - SUNDAY              
==========================================
Minutes 0 to 59 (columns left to right):
0              15             30             45         59
|              |              |              |          |

00:00  ■...........................................................  multicloud-sync
01:00  ■...........................................................  restic-lokaios
02:00  ............................................................  
03:00  ■.............................■.............................  restic-backup, vzdump-lokaios
04:00  ■...........................................................  restic-sync, update-twingate
```

### Year Heatmap Grid
```text
========================================================================
                    CRON YEAR HEATMAP — 2026                        
========================================================================
      JANUARI                   FEBRUARI                   MAART        
Ma Di Wo Do Vr Za Zo      Ma Di Wo Do Vr Za Zo      Ma Di Wo Do Vr Za Zo
         ■  ■  ■  ■                         ■                         ■ 
■  ■  ■  ■  ■  ■  ■       ■  ■  ■  ■  ■  ■  ■       ■  ■  ■  ■  ■  ■  ■ 
■  ■  ■  ■  ■  ■  ■       ■  ■  ■  ■  ■  ■  ■       ■  ■  ■  ■  ■  ■  ■ 
■  ■  ■  ■  ■  ■  ■       ■  ■  ■  ■  ■  ■  ■       ■  ■  ■  ■  ■  ■  ■ 
■  ■  ■  ■  ■  ■          ■  ■  ■  ■  ■  ■          ■  ■  ■  ■  ■  ■  ■ 
                                                    ■  ■                
```

---

## 🚀 Installation

You can install `CronTUI` as a single executable script in seconds.

### The Quick Way (One-Liner)
```bash
curl -sSL https://raw.githubusercontent.com/yourusername/crontui/main/crontui | sudo tee /usr/local/bin/crontui && sudo chmod +x /usr/local/bin/crontui
```

### Manual Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/crontui.git
   cd crontui
   ```
2. Move it to your path:
   ```bash
   sudo cp crontui /usr/local/bin/crontui
   sudo chmod +x /usr/local/bin/crontui
   ```

---

## 🛠️ Usage

Run the tool interactively:
```bash
crontui
```

### Navigation
Simply press the keys corresponding to your choice in the menu (no need to press Enter for the main selection):
- `1` - View Active Cronjobs
- `2` - Add a new Cronjob
- `3` - Remove a Cronjob
- `4` - Run a test execution
- `5` - View cron logs
- `7` - Run service health checks
- `8` - Show weekly visual timeline
- `9` - Show day zoom view (minute resolution)
- `m` - Show monthly calendar heatmap
- `j` - Show yearly heatmap grid

---

## ⚙️ Configuration (Optional)

`CronTUI` supports custom log directories and cron-digest run reports via environment variables.

| Variable | Description | Default |
| :--- | :--- | :--- |
| `CRONTUI_LOG_DIR` | Directory containing individual task logs (e.g. `*.last.log`). | `/var/lib/cron-notify` |
| `CRONTUI_DIGEST_FILE` | Path to a tab-separated TSV file logging cron runs (formatted as `Timestamp\tTask\tStatus\tDuration`). | `/var/lib/cron-notify/runs.tsv` |

If these files/directories are not present, `CronTUI` will automatically fall back to showing standard system logs via `journalctl` or `/var/log/syslog`.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to open issues or submit pull requests to improve the parser, add compatibility for other shells, or expand the visualizations.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
