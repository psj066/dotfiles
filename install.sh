#!/bin/bash

# 에러 발생 시 스크립트 중단 방지 (선택 사항, 여기선 로그 확인을 위해 계속 진행)
set -e

echo "🚀 Starting Dotfiles Installation..."

# -----------------------------------------------------------
# 1. Miniconda 설치 (Python 환경)
# -----------------------------------------------------------
if [ ! -d "$HOME/miniconda" ]; then
    echo "🐍 Installing Miniconda..."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
    bash ~/miniconda.sh -b -p $HOME/miniconda
    rm ~/miniconda.sh
    
    # 환경 변수 설정 (다음 로그인부터 적용되지만, 스크립트 내에서도 쓰기 위해 export)
    export PATH="$HOME/miniconda/bin:$PATH"
    conda init bash
else
    echo "✅ Miniconda already installed."
fi

# -----------------------------------------------------------
# 2. Electron GUI 지원을 위한 필수 패키지 설치 (Xvfb 등)
# -----------------------------------------------------------
echo "🖥️ Installing libraries for Electron (Headless/GUI support)..."
sudo apt-get update
# Ubuntu 24.04 (Noble) 호환 패키지명 적용 (libasound2 -> libasound2t64)
sudo apt-get install -y \
    xvfb \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libgtk-3-0 \
    libgbm1 \
    libasound2t64 \
    libxss1

# -----------------------------------------------------------
# 3. NPM 패키지 설치: Codex
# -----------------------------------------------------------
echo "📦 Installing OpenAI Codex CLI..."
# npm은 Codespaces 기본 이미지에 보통 설치되어 있음.
npm install -g @openai/codex

# -----------------------------------------------------------
# 4. Codex 자동 인증 설정 (GitHub Secrets 연동)
# -----------------------------------------------------------
echo "🔑 Configuring Codex Authentication..."
mkdir -p ~/.codex

if [ -n "$CODEX_AUTH_JSON" ]; then
    # Secrets에 저장된 내용을 파일로 생성
    echo "$CODEX_AUTH_JSON" > ~/.codex/auth.json
    echo "✅ Auth file created from Secrets."
else
    echo "⚠️ Warning: CODEX_AUTH_JSON secret not found. Manual login required."
fi

# -----------------------------------------------------------
# 5. 마무리
# -----------------------------------------------------------
echo "🎉 Installation Complete! Please restart your terminal."