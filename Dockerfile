# Use a Python image
FROM python:3.14-slim

# Copy uv from the official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV APP_HOME=/home/appuser
ENV PORT=8000

# Create a non-root user and group
RUN groupadd -r appgroup && useradd -r -g appgroup -m appuser

# Set workdir
WORKDIR ${APP_HOME}

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies using uv
RUN uv sync --frozen --no-dev --no-install-project

# Copy the application code
COPY main.py .

# Change ownership
RUN chown -R appuser:appgroup ${APP_HOME}

# Switch to non-root user
USER appuser

# Expose the port
EXPOSE ${PORT}

# Run the application
CMD ["uv", "run", "fastapi", "run", "main.py", "--port", "8000", "--host", "0.0.0.0"]