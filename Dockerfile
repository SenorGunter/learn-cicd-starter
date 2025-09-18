FROM --platform=linux/amd64 debian:stable-slim

# Install only what we need, then clean up to keep the image small
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy the Go binary from bin/ into the container
ADD bin/notely /usr/bin/notely

# Run the app when the container starts
CMD ["notely"]
