# CronTUI ⏰📊

```text
  ____                 _____ _   _ ___ 
 / ___|_ __ ___  _ __ |_   _| | | |_ _|
| |   | '__/ _ \| '_ \  | | | | | || | 
| |___| | | (_) | | | | | | | |_| || | 
 \____|_|  \___/|_| |_| |_|  \___/|___|
```

[![Language-Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Helper-Python](https://img.shields.io/badge/Helper-Python-3776AB?style=flat-square&logo=python&logoColor=white)](https://www.python.org/)
[![Dependencies-None](https://img.shields.io/badge/Dependencies-None-brightgreen?style=flat-square)](#)
[![Interface-TUI](https://img.shields.io/badge/Interface-TUI-blue?style=flat-square)](#)
[![License-MIT](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

A beautiful, dependency-free terminal-based visualizer and manager for your cronjobs.

`CronTUI` is a standalone, lightweight Bash utility that transforms the standard, dry crontab management experience into an interactive, color-coded visual agenda. It lets you analyze your cron scheduling patterns over days, weeks, months, and years in a clean TUI heatmap—helping you identify execution overlap and schedule conflicts instantly.

---

## 📽️ Demo

*(To capture an animated demo of CronTUI, run `asciinema rec demo.cast`, convert it using `svg-term` or compile to a GIF, and embed it here!)*

```text
[   Interactive Demo / GIF Placeholder   ]
```

---

## 🤔 Why CronTUI?

- 🚫 **No Web Overhead**: Unlike heavy web-based crontab dashboards, CronTUI runs instantly in any SSH terminal session without needing to open ports, map web servers, or set up reverse proxies.
- 🎨 **Rich TUI vs. `crontab -l`**: Standard crontab commands return unreadable lists of raw text. CronTUI interprets and plots scheduling patterns on visual, color-coded heatmaps.
- ⚡ **No Complex Setup**: It is a single, self-contained executable with zero dependencies—no node_modules, no python virtual environments, just raw bash and the Python standard library.
- 🛠️ **Sandboxed Testing & Safety**: Safe addition and deletion wizard prevents syntax mistakes, while the sandboxed test-run allows executing cronjobs manually with a single keystroke.

---

## 🌟 Features

- 📂 **Safe Cron Management**: View active cronjobs, add new ones with validation, and safely remove them by index.
- ⚡ **On-Demand Testing**: Run any cronjob command manually in a sandbox environment right from the CLI.
- 📆 **Week Timeline**: View a horizontal hour-by-hour weekly grid mapping when tasks are scheduled.
- 🔍 **Day Zoom View**: Drill down into a specific day to see a 60-minute horizontal timeline showing exactly which minute a job runs, complete with job command labels.
- 📅 **Month Heatmap**: Visual month-calendar heatmap representing job density per day.
- 🗺️ **Year Heatmap**: A stunning 3x4 grid rendering of all 12 months with day-by-day job density heatmaps.
- 🏥 **Health & Logs**: Easily check service status (cron/crond), task count, view syslogs via `journalctl`, and view custom task logs if available.

---

## 🚀 Installation

You can install `CronTUI` as a single executable script in seconds.

### The Quick Way (One-Liner)
```bash
curl -sSL https://raw.githubusercontent.com/Piggy90/crontui/main/crontui | sudo tee /usr/local/bin/crontui && sudo chmod +x /usr/local/bin/crontui
```

### Manual Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/Piggy90/crontui.git
   cd crontui
   ```
2. Move it to your path:
   ```bash
   sudo cp crontui /usr/local/bin/crontui
   sudo chmod +x /usr/local/bin/crontui
   ```

---

## 🛠️ Command-Line Options

CronTUI supports direct CLI arguments for diagnostic and utility purposes:

```text
Usage:
  crontui [options]

Options:
  -h, --help      Show this help message and exit
  -v, --version   Show version information and exit
  -d, --doctor    Run environment health diagnostics
```

### Environment Doctor (`crontui --doctor`)
Runs a series of environment diagnostics checking for Python availability, service execution state, crontab permissions, and log directory mapping:

```text
==========================================
           CRONTUI DOCTOR DIAGNOSTICS      
==========================================
Checking Python 3... OK (Python 3.11.2)
Checking Cron service... OK (Active and running)
Checking crontab access... OK (Accessible)
Checking log directory (/var/lib/cron-notify)... OK (Exists)
Checking digest file (/var/lib/cron-notify/runs.tsv)... OK (Exists)

Summary: 0 error(s), 0 warning(s)
✔ Your environment is ready for CronTUI!
```

---

## ⚙️ Configuration (Optional)

`CronTUI` supports custom log directories and cron-digest run reports via environment variables.

| Variable | Description | Default |
| :--- | :--- | :--- |
| `CRONTUI_LOG_DIR` | Directory containing individual task logs (e.g. `*.last.log`). | `/var/lib/cron-notify` |
| `CRONTUI_DIGEST_FILE` | Path to a tab-separated TSV file logging cron runs (formatted as `Timestamp\tTask\tStatus\tDuration`). | `/var/lib/cron-notify/runs.tsv` |

If these files/directories are not present, `CronTUI` will automatically fall back to showing standard system logs via `journalctl` or `/var/log/syslog`.

---

## 🗺️ Roadmap

We are continuously improving `CronTUI`. Here is our planned roadmap:

- [ ] **Cron Conflict Detection**: Warn users if two memory-heavy or disk-heavy tasks overlap on the schedule.
- [ ] **Live Mode**: Real-time auto-refresh of timelines and heatmaps as time passes.
- [ ] **JSON Export**: Export the parsed schedule and active timelines to structured JSON files.
- [ ] **TUI Filters**: Filter the week, month, and year views by specific search terms or commands.
- [ ] **Plugin System**: Allow custom scripts to extend visual heatmaps or logging integrations.

---

## 🤝 Contributing

Contributions are welcome! To contribute:
1. **Fork** the repository.
2. Create a new feature branch (`git checkout -b feature/amazing-feature`).
3. Commit your changes (`git commit -m 'Add amazing feature'`).
4. Push to the branch (`git push origin feature/amazing-feature`).
5. Open a **Pull Request**.

### Coding Style & Rules
- Keep the main runner 100% self-contained in the `crontui` script.
- Ensure Python helpers use only the standard library (no pip packages).
- Verify shell syntax using `bash -n crontui` before committing.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
