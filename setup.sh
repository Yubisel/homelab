#!/usr/bin/env bash
# setup.sh — Install Docker and Task for the homelab
# Supports: Ubuntu/Debian, Fedora/RHEL/CentOS, Alpine, macOS

set -euo pipefail

# ── Helpers ──────────────────────────────────────────────────────────────────

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[+]${NC} $*"; }
warning() { echo -e "${YELLOW}[!]${NC} $*"; }
error()   { echo -e "${RED}[x]${NC} $*" >&2; exit 1; }

command_exists() { command -v "$1" &>/dev/null; }

# ── OS detection ─────────────────────────────────────────────────────────────

detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
  elif [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    case "$ID" in
      ubuntu|debian|linuxmint) OS="debian" ;;
      fedora|rhel|centos|rocky|almalinux) OS="fedora" ;;
      alpine) OS="alpine" ;;
      *) error "Unsupported Linux distro: $ID. Install Docker and Task manually." ;;
    esac
  else
    error "Cannot detect OS. Install Docker and Task manually."
  fi
  info "Detected OS: $OS"
}

# ── Docker ───────────────────────────────────────────────────────────────────

install_docker_debian() {
  info "Installing Docker (apt)..."

  # Remove conflicting packages
  for pkg in docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc; do
    sudo apt-get remove -y "$pkg" 2>/dev/null || true
  done

  sudo apt-get update -y
  sudo apt-get install -y ca-certificates curl

  # Add Docker GPG key
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add Docker apt repository
  # shellcheck source=/dev/null
  . /etc/os-release
  sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/${ID}
Suites: ${UBUNTU_CODENAME:-${VERSION_CODENAME}}
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

  sudo apt-get update -y
  sudo apt-get install -y \
    docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin
}

install_docker_fedora() {
  info "Installing Docker (dnf)..."
  sudo dnf remove -y docker docker-client docker-client-latest \
    docker-common docker-latest docker-latest-logrotate \
    docker-logrotate docker-selinux docker-engine-selinux \
    docker-engine 2>/dev/null || true

  sudo dnf install -y dnf-plugins-core
  sudo dnf config-manager --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf install -y \
    docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin
  sudo systemctl start docker
}

install_docker_alpine() {
  info "Installing Docker (apk)..."
  sudo apk add --update docker docker-compose
  sudo rc-update add docker default
  sudo service docker start
}

install_docker_macos() {
  if ! command_exists brew; then
    error "Homebrew not found. Install it first: https://brew.sh"
  fi
  info "Installing Docker Desktop (brew)..."
  brew install --cask docker
  warning "Open Docker Desktop from Applications to complete the setup."
}

configure_docker_linux() {
  info "Configuring Docker post-install..."

  # Enable and start Docker service
  sudo systemctl enable --now docker.service
  sudo systemctl enable --now containerd.service

  # Add current user to the docker group (no sudo needed)
  if ! groups "$USER" | grep -q docker; then
    sudo groupadd -f docker
    sudo usermod -aG docker "$USER"
    warning "User '$USER' added to the 'docker' group."
    warning "Log out and back in (or run 'newgrp docker') for this to take effect."
  fi
}

install_docker() {
  if command_exists docker; then
    info "Docker already installed: $(docker --version)"
    return
  fi

  case "$OS" in
    debian) install_docker_debian ;;
    fedora) install_docker_fedora ;;
    alpine) install_docker_alpine ;;
    macos)  install_docker_macos ;;
  esac

  if [[ "$OS" != "macos" ]]; then
    configure_docker_linux
  fi

  info "Docker installed: $(docker --version)"
}

# ── Task ─────────────────────────────────────────────────────────────────────

install_task_debian() {
  info "Installing Task (apt)..."
  curl -1sLf 'https://dl.cloudsmith.io/public/task/task/setup.deb.sh' | sudo -E bash
  sudo apt-get install -y task
}

install_task_fedora() {
  info "Installing Task (dnf)..."
  curl -1sLf 'https://dl.cloudsmith.io/public/task/task/setup.rpm.sh' | sudo -E bash
  sudo dnf install -y task
}

install_task_alpine() {
  info "Installing Task (apk)..."
  curl -1sLf 'https://dl.cloudsmith.io/public/task/task/setup.alpine.sh' | sudo -E bash
  sudo apk add task
}

install_task_macos() {
  if ! command_exists brew; then
    error "Homebrew not found. Install it first: https://brew.sh"
  fi
  info "Installing Task (brew)..."
  brew install go-task
}

install_task() {
  if command_exists task; then
    info "Task already installed: $(task --version)"
    return
  fi

  case "$OS" in
    debian) install_task_debian ;;
    fedora) install_task_fedora ;;
    alpine) install_task_alpine ;;
    macos)  install_task_macos ;;
  esac

  info "Task installed: $(task --version)"
}

# ── Shared Docker network ─────────────────────────────────────────────────────

setup_network() {
  if docker network inspect proxy-net &>/dev/null; then
    info "Docker network 'proxy-net' already exists."
  else
    info "Creating Docker network 'proxy-net'..."
    docker network create proxy-net
    info "Network 'proxy-net' created."
  fi
}

# ── Main ─────────────────────────────────────────────────────────────────────

main() {
  echo ""
  echo "  Homelab setup"
  echo "  ─────────────────────────────────────────"
  echo ""

  detect_os
  echo ""

  install_docker
  echo ""

  install_task
  echo ""

  setup_network
  echo ""

  info "Setup complete. Run 'task init' to start all services."
  echo ""
}

main "$@"
