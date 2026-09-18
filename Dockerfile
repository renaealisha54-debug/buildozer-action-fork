FROM ghcr.io/kivy/buildozer:latest
# See https://github.com/kivy/buildozer/blob/master/Dockerfile

# The base image sets $USER and $HOME_DIR and creates the home directory,
# but never actually creates a matching Linux user account. Later steps
# (entrypoint.py) run `sudo chown -R "$USER" ...`, which fails with
# "invalid user" unless the account really exists. Create it if missing.
RUN id -u "$USER" >/dev/null 2>&1 || useradd -m -d "$HOME_DIR" -s /bin/bash "$USER"

# Buildozer will be installed in entrypoint.py
# This is needed to install version specified by user
RUN pip3 uninstall -y buildozer

# Get the latest JDK version as Buildozer requires the latest version to build the APK
RUN sudo apt-get update && \
    sudo apt-get install -y software-properties-common && \
    sudo rm -rf /var/lib/apt/lists/*
RUN sudo apt-get update
RUN sudo apt-get -y install openjdk-17-jdk

# Remove a lot of warnings
# sudo: setrlimit(RLIMIT_CORE): Operation not permitted
# See https://github.com/sudo-project/sudo/issues/42
RUN echo "Set disable_coredump false" | sudo tee -a /etc/sudo.conf > /dev/null

# By default Python buffers output and you see prints after execution
# Set env variable to disable this behavior
ENV PYTHONUNBUFFERED=1

COPY entrypoint.py /action/entrypoint.py
ENTRYPOINT ["/action/entrypoint.py"]
