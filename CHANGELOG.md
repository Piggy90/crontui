# Changelog

All notable changes to the `CronTUI` project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.2.0] - 2026-06-30

### Added
- **In-place Cron Editing**: Added interactive menu option `3` to edit existing cronjobs (schedule expression, command, and status) in-place without deleting and recreating.
- **Task Suspend and Resume**: Added interactive menu option `5` to toggle cronjob active state (`AAN`/`UIT`) by comment-prefixing (`# `) directly in the user's crontab while fully preserving formatting and surrounding comment blocks.

## [1.1.2] - 2026-06-23

### Added
- **Interactive Visual Styling**: Colorful outputs in conflict detection (Yellow for warnings, Cyan for jobs, Red for times, Dim for dividers) with built-in `NO_COLOR` environment variable support.
- **Command Path Toggle**: Interactive `v` key toggle in the conflict detector to switch dynamically between simplified command labels and full command paths.

## [1.1.1] - 2026-06-23

### Added
- **Command De-cluttering**: Cleans up and simplifies cronjob command paths and notification wrappers (such as `cron-notify.sh` or complex bash execution subshells) in the interactive conflict visualizer for improved readability.

## [1.1.0] - 2026-06-23

### Added
- **Cron Conflict Detection**: A new interactive menu option `c` that parses the crontab and flags scheduling conflicts where multiple cronjobs are scheduled at the exact same minute within the weekly cycle. It highlights the overlapping jobs and displays the list of conflict times (excluding high-frequency daemon-like jobs that run every minute to prevent visual noise).

## [1.0.0] - 2026-06-22

### Added
- **Visual Timelines**:
  - Horizontal **Week Timeline** mapping hourly schedule density.
  - Interactive **Day Zoom View** showing minute-resolution horizontal slots with consolidated job labels.
  - **Month Heatmap** visual calendar showing active scheduling density.
  - **Year Heatmap** rendering a 3x4 grid of all 12 months with day-by-day job density blocks (`■`).
- **Interactive TUI Core**:
  - Main menu interface using zero-delay single-key selections.
  - Safe interactive cron addition with validation and removal by index.
  - On-demand sandboxed execution/test-runs of active cronjobs.
  - Service health checking (daemon active state, active jobs count, and syslog inspection).
  - Configurable environment variable overrides for custom log and digest directories (`CRONTUI_LOG_DIR`, `CRONTUI_DIGEST_FILE`).
- **Doctor Diagnostics**: Command-line flag `--doctor` / `-d` to run environment health checks.
- **Documentation**: Professional English README.md with ASCII diagrams and installation guide.
