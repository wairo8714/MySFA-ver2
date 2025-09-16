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
EC2_HOST="43.207.66.4"
SSH_KEY="infrastructure/mysfa-dev-keypair"
ALLOWED_HOSTS="43.207.66.4,mysfa.net"

echo -e "${GREEN}MySFA デプロイを開始します...${NC}"

# 1. ファイルをアップロード
echo -e "${YELLOW}ファイルをアップロード中...${NC}"
scp -i $SSH_KEY -o StrictHostKeyChecking=no -r src/ docker/ requirements.txt ec2-user@$EC2_HOST:/home/ec2-user/

# 2. Dockerイメージを再ビルド
echo -e "${YELLOW}Dockerイメージを再ビルド中...${NC}"
ssh -i $SSH_KEY -o StrictHostKeyChecking=no ec2-user@$EC2_HOST "cd /home/ec2-user && sudo docker build -f docker/Dockerfile -t mysfa-app ."

# 3. 既存のコンテナを停止・削除
echo -e "${YELLOW}既存のコンテナを停止中...${NC}"
ssh -i $SSH_KEY -o StrictHostKeyChecking=no ec2-user@$EC2_HOST "sudo docker stop mysfa-app || true && sudo docker rm mysfa-app || true"

# 4. 新しいコンテナを起動
echo -e "${YELLOW}新しいコンテナを起動中...${NC}"
ssh -i $SSH_KEY -o StrictHostKeyChecking=no ec2-user@$EC2_HOST "sudo docker run -d --name mysfa-app -p 127.0.0.1:8000:8000 -e ALLOWED_HOSTS=$ALLOWED_HOSTS mysfa-app"

# 5. ヘルスチェック
echo -e "${YELLOW}🔍 ヘルスチェック中...${NC}"
sleep 10

if curl -f -s https://mysfa.net > /dev/null; then
    echo -e "${GREEN}デプロイが完了しました！${NC}"
    echo -e "${GREEN}アプリケーション: https://mysfa.net${NC}"
else
    echo -e "${RED}デプロイに失敗しました${NC}"
    echo -e "${YELLOW}ログを確認してください:${NC}"
    ssh -i $SSH_KEY -o StrictHostKeyChecking=no ec2-user@$EC2_HOST "sudo docker logs mysfa-app"
    exit 1
fi
