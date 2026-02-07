#!/usr/bin/env bash
set -e

# 只添加 iStoreOS 生态核心 feeds：
# - store: linkease/istore（iStore 本体）
# - istore_packages: linkease/istore-packages（iStoreOS 固定版本包集合）
# 资料：iStore 仓库说明、istore-packages 说明:contentReference[oaicite:3]{index=3}

add_feed_if_not_exists() {
  local name="$1"
  local url="$2"
  local branch="${3:-main}"

  # feeds.conf.default 不存在就创建
  [ -f feeds.conf.default ] || touch feeds.conf.default

  if ! grep -qE "^[[:space:]]*src-git[[:space:]]+${name}[[:space:]]" feeds.conf.default; then
    echo "src-git ${name} ${url};${branch}" >> feeds.conf.default
    echo "[+] Added feed: ${name} -> ${url};${branch}"
  else
    echo "[=] Feed exists: ${name}"
  fi
}

# iStore / iStore-packages
add_feed_if_not_exists "store" "https://github.com/linkease/istore" "main"
add_feed_if_not_exists "istore_packages" "https://github.com/linkease/istore-packages" "main"

# 更新并安装新增 feeds
./scripts/feeds update store istore_packages
./scripts/feeds install -a -p store
./scripts/feeds install -a -p istore_packages

echo "[OK] iStoreOS feeds ready."
