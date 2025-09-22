#!/bin/bash

# MySFA デプロイスクリプト
# 使用方法: ./deploy.sh

set -e  # エラー時に停止

# 色付きの出力
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 設定
EC2_HOST="54.199.78.127"
SSH_KEY="infrastructure/mysfa-dev-keypair"
ALLOWED_HOSTS="54.199.78.127,mysfa.net"

echo -e "${GREEN}MySFA デプロイを開始します...${NC}"

# 1. ファイルをアップロード
echo -e "${YELLOW}ファイルをアップロード中...${NC}"
scp -i $SSH_KEY -o StrictHostKeyChecking=no -r src/ docker/ requirements.txt ec2-user@$EC2_HOST:/home/ec2-user/

# 2. Docker Composeでアプリケーションを起動
echo -e "${YELLOW}Docker Composeでアプリケーションを起動中...${NC}"
ssh -i $SSH_KEY -o StrictHostKeyChecking=no ec2-user@$EC2_HOST "cd /home/ec2-user && sudo docker-compose down || true"
ssh -i $SSH_KEY -o StrictHostKeyChecking=no ec2-user@$EC2_HOST "cd /home/ec2-user && sudo docker-compose up -d --build"

# 5. ヘルスチェック
echo -e "${YELLOW}🔍 ヘルスチェック中...${NC}"
sleep 10

if curl -f -s https://mysfa.net > /dev/null; then
    echo -e "${GREEN}デプロイが完了しました！${NC}"
    echo -e "${GREEN}アプリケーション: https://mysfa.net${NC}"
else
    echo -e "${RED}デプロイに失敗しました${NC}"
    echo -e "${YELLOW}ログを確認してください:${NC}"
    ssh -i $SSH_KEY -o StrictHostKeyChecking=no ec2-user@$EC2_HOST "sudo docker logs ec2-user-app-1"
    exit 1
fi
