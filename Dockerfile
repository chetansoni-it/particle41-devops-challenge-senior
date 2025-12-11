# Use a minimal base image (e.g., Python slim or alpine variants)
FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED 1
ENV APP_HOME /home/simple_time_service
ENV PORT 8080

# Create a non-root user and group
RUN groupadd -r appgroup && useradd -r -g appgroup -m appuser

# Create application directory and set permissions
RUN mkdir -p ${APP_HOME} && chown -R appuser:appgroup ${APP_HOME}

# Set the working directory to the non-root user's home
WORKDIR ${APP_HOME}

# Copy dependencies and install them
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY SimpleTimeService.py .

# Expose the port the app runs on
EXPOSE ${PORT}

# Switch to the non-root user BEFORE running the application
USER appuser

# Command to run the application
CMD ["python", "SimpleTimeService.py"]