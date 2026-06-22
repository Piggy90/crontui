# Changelog

All notable changes to the `CronTUI` project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

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
