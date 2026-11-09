#!/usr/bin/env bash
# ============================================================
# BÀI 3 - Deploy BẰNG TAY vào workspace Coder.
# Nguyên tắc: làm tay thành công trước, rồi mới tự động hóa (Bài 4).
# Job "deploy" ở Bài 4 sẽ làm lại đúng các lệnh trong file này.
#
# Cách dùng (chạy từ máy bạn, sau khi đã `coder login`):
#   bash scripts/manual-deploy.sh <tên-workspace> <sha-hoặc-latest>
# Ví dụ:
#   bash scripts/manual-deploy.sh site-staging latest
#   bash scripts/manual-deploy.sh site-staging 42556642879abc...   # SHA đầy đủ
# ============================================================
set -euo pipefail   # lỗi ở bất kỳ lệnh nào thì dừng ngay

WORKSPACE="${1:?Thiếu tên workspace. Ví dụ: site-staging}"
TAG="${2:?Thiếu tag. Dùng SHA của commit hoặc latest}"

# Tên image trên GHCR (bắt buộc chữ thường).
IMAGE="ghcr.io/nguyenleminhbaott5/ci-cd-practice:${TAG}"

# coder ssh trong Git Bash (mintty) không tự thoát sau khi lệnh xong vì chờ bàn phím.
# </dev/null cho nó đầu vào rỗng để phiên tự đóng.
cs() { coder ssh "$@" </dev/null; }

echo "==> 1. Kiểm tra Docker chạy được trong workspace"
cs "$WORKSPACE" "docker ps"

echo "==> 2. Kéo image về (nếu image private: docker login ghcr.io trước, xem README bài 3)"
cs "$WORKSPACE" "docker pull $IMAGE"

echo "==> 3. Xóa container cũ (nếu có) rồi chạy container mới ở cổng 8080"
cs "$WORKSPACE" "docker rm -f site || true"
cs "$WORKSPACE" "docker run -d --name site --restart unless-stopped -p 8080:80 $IMAGE"

echo "==> 4. Kiểm tra trang chạy thật"
sleep 3
cs "$WORKSPACE" "curl -fsS http://localhost:8080/"
echo
echo "OK. Mở trang qua coder_app (cổng 8080) trên giao diện Coder."
