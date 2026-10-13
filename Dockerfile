# The image MATHutrice runs from: built once per commit, run unchanged in every
# environment. It holds the code and its locked dependencies and no setting:
# each environment hands its own to the container at run time.
#
#     docker build -t mathutrice .
#     docker run --env-file .env -p 8000:8000 mathutrice
FROM python:3.14.7-slim

# uv installs the versions in uv.lock, as on a contributor's machine.
COPY --from=ghcr.io/astral-sh/uv:0.12.22 /uv /bin/uv

# The base image already is the Python of .python-version: uv must not fetch another.
ENV UV_PYTHON_DOWNLOADS=never \
    UV_LINK_MODE=copy \
    PYTHONUNBUFFERED=1

WORKDIR /app

# The dependencies get their own layer, so a commit that changes only the code
# rebuilds only the layers below. The dev group (pytest, tach) stays out.
COPY pyproject.toml uv.lock .python-version ./
RUN uv sync --locked --no-dev --no-install-project

COPY mathutrice ./mathutrice
RUN uv sync --locked --no-dev

# The application writes in two places: uploaded PDFs in mathutrice/rag_documents,
# and the SQLite file in the working directory. The process owns those and nothing else.
RUN useradd --system --no-create-home app \
    && mkdir -p mathutrice/rag_documents \
    && chown app /app mathutrice/rag_documents
USER app

ENV PATH="/app/.venv/bin:$PATH"

# One process, in exec form so that it is the container's main process and
# receives the stop signal. The scheduler that cleans up old conversations runs
# inside it (app.py, lifespan).
EXPOSE 8000
CMD ["uvicorn", "mathutrice.app:app", "--host", "0.0.0.0", "--port", "8000"]
