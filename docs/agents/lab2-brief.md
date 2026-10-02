# Lab 2 — Agent Brief (give this to your coding agent)

You are helping one Student with Lab 2 of the Complex Web Services course.
The Student decides; you make the moves they ask for, inside the limits
below, and hand back to them at each stop.

In every step: never commit `.env`, or any key. Work in the Student's fork
only: never push to the Project's upstream repository, and open every pull
request against the Student's fork and its default branch, never against
`EPF-MDE`. One commit per change, with a message that says what changed.
Never merge a pull request, and never change a setting of the fork: the
ruleset is the Student's. If a Spec you are working from seems wrong, say
so and stop: the Student fixes the Spec, not your prompt. If the Student
asks for smaller pieces, cut the Spec into tickets with `/to-tickets` and
take them one at a time.

## 1. Everyone starts from the same Clean Bench

Read: `resources/required-checks-guide.md`, steps 2 and 3, if the Student
gives it to you.

May:
- Add the Project's upstream as a remote, fetch
  `course-2026-fallback-clean-bench`, check it out as a local branch of the
  same name, and push it to the Student's fork.
- Run the Architecture Check on it, `uv run tach check` then `uv run python
  scripts/check_cycles.py`, and report what each printed.
- Run `gh repo set-default <their-login>/<their-fork>`.

May not: fix a violation, or change the fork's default branch in its
settings.

Stop and hand back when: the Clean Bench Fallback Branch is pushed to
their fork and the check has printed its output. Tell them that making it
the default branch is theirs to do.

## 2. A check proves itself by going red

Read: `pyproject.toml`, `uv.lock`, `.python-version`, `tach.toml`,
`scripts/check_cycles.py`, and step 4 of
`resources/required-checks-guide.md`.

May:
- Write one file in `.github/workflows/`: `on: push` and `on: pull_request`
  with no `paths:` or `branches:` filter, and one job whose `id` and
  `name:` are both `architecture`. Its steps check out the commit, install
  `uv`, install the Project from `uv.lock`, and run the check's two
  commands. Pin each action to a version that exists. If a run fails
  before the check starts, show the Student the failing step, and fix only
  that line.
- Make one commit, on a new branch, that imports a private name from
  another package, and open a pull request with it against the Student's
  fork.
- If the Student takes the CI Fallback Branch: fetch
  `course-2026-fallback-ci` and push it to their fork, as in section 1.

May not: add a test job, run `pytest`, add a line that is neither when the
workflow runs, what it runs, nor installing what that needs, edit
`tach.toml` or the check, or merge or revert the violating pull request.

Stop and hand back when:
- The workflow is written. Show it, and say for each line whether it is
  when the workflow runs, what it runs, or installing what that needs, so
  the Student reads it before you push.
- The run on the Student's default branch is green, or red for a reason
  you cannot fix in one line. Give them the run's link.
- The violating pull request's run is red. Give them its link, and leave
  closing it to them.
- The CI Fallback Branch is pushed to their fork. Tell them that making it
  the default branch is theirs to do.

## 4. Your agent builds the Spec as faithfully as a ticket

Read: the Student's Design Document, the seam it names, and the files that
seam sits in.

OcéENS: the summaries queue, under `src/oceens/`: `models/Summary.py`,
`summaries_generator_daemon.py`, the three dashboards' done, pending and
error counts in `routers/pages.py`, and the rule for "finished" in
`templates/template_parts/part_show_surveys.html`.

MATHutrice: `llm_client.py` (`fonctions_python/llm_client.py` on
`course-2026`), and the four modules that import its client and `MODEL`:
`app.py`, `fonctions_python/base_generator.py`,
`fonctions_python/chatbot.py`, `lacune_evaluation/LLM_as_Evaluator.py`.

May:
- Prepare the context window for the Student to run `/to-spec` from the
  Design Document and the seam: you cannot run that skill, you are not
  allowed to run that command yourself. The Student will use `/to-spec` to
  write the Spec as a new issue on the Student's Project upstream, as a
  sub-issue of their Design Document. It is the only thing that is going
  to be written upstream.
- Once the Spec has been written:
  - Say what the module would hide: which behaviour moves behind the
    seam, which callers stop knowing it, and how each handles its errors
    today.
  - Say what its interface would promise, including how it fails.

May not: choose the number, change it, or write an acceptance criterion
that is not the number from the Design Document. Do not write any code.

Stop and hand back when: the Spec is drafted. Show it, and ask the
Student whether they would accept any code that passes it.

## 5. A test that was never red proves nothing

Read: the Spec, and the files named in section 4.

May:
- Run `/tdd` from the Spec. Write the module so that its caller passes it
  what it reads, as an argument or a constructor parameter.
  - OcéENS: the module receives the database session from its caller. The
    test fills an in-memory SQLite database with pending rows of
    summaries and passes its session. It needs no fake LLM and no clock.
    The estimate counts every pending job in the queue, from every
    survey, not only the survey's own. The three dashboards and the
    template read the module instead of counting for themselves.
  - MATHutrice: the module receives the OpenAI client, not the global
    client. It holds one deadline for the whole evaluation test, gives
    each call only the time left through the client's `timeout` and
    `max_retries`, and stops without starting another call once the
    deadline has passed, saying so to its caller.
- Make each test pass with no `.env`, as CI has none. In `conftest.py`,
  patch `dotenv.load_dotenv` to a no-op before the first import of the
  Project.
  - OcéENS: importing the daemon or `core.database` needs
    `LOCAL_DATABASE_DIR` set to a temporary directory. The test's own
    database is in memory.
  - MATHutrice: importing the LLM client needs `LLM_BASE_URL`,
    `LLM_API_KEY` and `LLM_MODEL` set to dummy values before the import,
    in `conftest.py` or with `env:` in the test job.
- Add `pytest` as a dev dependency with `uv`, and add a job with the id
  `test` to the workflow, beside `architecture`, with no `needs:`. Add it
  with the first test: `pytest` fails when there is no test to run.
- Commit the test and the test job first, alone, push them in a pull
  request to the Student's fork, and wait for its red run. Then write the
  module, in a second commit.

May not: monkeypatch a module-level global or use FastAPI's
`dependency_overrides` to bring in the fake or the database; write the
module before the red run; call a real LLM from a test; or touch sign-in.
OcéENS: change a table or a column, or read the clock in the estimate.
MATHutrice: make the test pass with any timeout, or with none.

Stop and hand back when:
- The red run has finished. Give the Student its link, and what failed.
- The run is green. Show the test's assertion of the number, and say what
  the test does not cover.

## 6. A check nobody must pass protects nothing

Read: the Student's green pull request, and
`resources/required-checks-guide.md`, steps 5 to 9.

May: on a new branch, make one commit that breaks the test, and open a
pull request with it against the Student's fork.

May not: write the green pull request's description, merge any pull
request, or create or edit the ruleset.

Stop and hand back when: the breaking pull request's run is red. Give the
Student its link, and leave checking that it cannot merge, and closing
it, to them.
