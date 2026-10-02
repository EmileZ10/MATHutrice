## Agent skills

### Issue tracker

Issues are tracked in GitHub Issues on `EPF-MDE/MATHutrice` via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `CONTEXT.md` + `docs/adr/` at the repo root. See `docs/agents/domain.md`.

### Package boundaries

Package boundaries are machine-checked: read `mathutrice/README.md` before adding a package, or importing across one.

### Lab 1 brief

Constraints for Lab 1 (package-boundary fixes via the Architecture Check,
and facts-only answers for the `POST /session/evaluation` sizing question).
One commit per fix, never silence a violation, stop at any choice of
interface or design. See `docs/agents/lab1-brief.md`.
