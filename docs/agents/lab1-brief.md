# Lab 1 — Agent Brief

The Student decides; the agent makes the moves the Student asks for, inside
the limits below, and hands back at each stop.

Always:
- Never commit `.env` or any key.
- Work in the Student's fork only: never push to the upstream
  `EPF-MDE/MATHutrice` repo, and never open a pull request against it unless
  the Student asks for one.
- One commit per change, with a message that says what changed.
- Today's scope is moving, renaming and splitting files. No design: a
  change that needs a choice of what a caller sees is not the agent's to
  make.

## 1. Only a Project that runs within its boundaries can be measured

Read first: `docs/smoke-test.md`, `README.md`, `.env.example`, the issue the
Student names (`EPF-MDE/MATHutrice#22`, `#20` or `#32`), and the
Architecture Check's output.

May:
- Run the commands in `docs/smoke-test.md`, in order, and report what each
  printed.
- Edit the README so every instruction in it is true of the code, and link
  it to `docs/smoke-test.md` instead of repeating it.
- Edit the seed, and the files its issue names, until the database is
  seeded.
- For a cycle between two packages: move the whole file that crosses the
  edge into the package where it belongs, or move one shared value into a
  module of its own.
- For a private name that more than one module outside its package
  imports: drop its leading underscore, re-export it in its package's
  `__init__.py`, and list it in `__all__`.
- Change the import paths and calls that follow from any of these moves.

May not:
- Add a function, change a signature, rewrite a body, fix two violations in
  one commit, edit `tach.toml` or the check to silence a violation, write a
  CI workflow, or install `py-deepmodules` into the project.

Stop and hand back when:
- A smoke-test command fails and its issue doesn't say how to fix it — show
  the command and what it printed.
- A private name has only one importer outside its package, or a fix needs
  a new function, a changed signature, or a choice of what a caller sees —
  name the violation, say which of these it needs, and change nothing for
  it.
- One violation is fixed — show its diff and the check's new output, so the
  Student reads the diff before the next one.
- The check prints no violation.

## 3. A number nobody gives you comes from the code and your assumption

Read: `mathutrice/app.py` from the route for `POST /session/evaluation`,
and every function and library it calls.

May:
- Answer each part of the Student's question from the code, with the file
  and line each answer comes from.
- Run the Project locally, and time one request the Student names.

May not:
- Choose the assumption, give the number, write in the Design Document,
  propose an interface for the seam, change any code, or post on an issue.

Stop and hand back when every part of the question has an answer with its
file and line. Give the facts only — leave the assumption, the number and
the seam to the Student.