# MySFA - 営業支援システム

![Django](https://img.shields.io/badge/Django-5.0.14-green)
![Python](https://img.shields.io/badge/Python-3.12-blue)
![AWS](https://img.shields.io/badge/AWS-EC2-orange)
![Docker](https://img.shields.io/badge/Docker-Container-blue)
![HTTPS](https://img.shields.io/badge/HTTPS-Let's%20Encrypt-green)

## 🌟 概要

MySFAは営業チーム向けのWebアプリケーションです。顧客管理、商品管理、チーム管理機能を提供し、営業活動の効率化を支援します。

**デモサイト**: [https://mysfa.net](https://mysfa.net)

## ✨ 主な機能

- **ユーザー管理**: アカウント作成、ログイン、プロフィール管理
- **顧客管理**: 顧客情報の登録・検索・編集
- **商品管理**: 商品情報の管理
- **チーム管理**: グループ作成、メンバー管理
- **投稿機能**: 営業活動の記録・共有
- **検索機能**: 顧客・商品・ユーザーの検索

## 🛠️ 技術スタック

### フロントエンド
- **HTML5/CSS3**: レスポンシブデザイン
- **JavaScript**: インタラクティブなUI
- **Bootstrap**: モダンなUIコンポーネント

### バックエンド
- **Django 5.0.14**: Webフレームワーク
- **Python 3.12**: プログラミング言語
- **SQLite**: データベース（開発環境）
- **WhiteNoise**: 静的ファイル配信

### インフラストラクチャ
- **AWS EC2**: クラウドサーバー
- **Docker**: コンテナ化
- **Nginx**: リバースプロキシ・SSL終端
- **Let's Encrypt**: SSL証明書
- **Route 53**: DNS管理

### 開発・運用
- **GitHub Actions**: CI/CD
- **Terraform**: Infrastructure as Code
- **Docker Compose**: ローカル開発環境

## 🚀 セットアップ

### 前提条件
- Python 3.12+
- Docker & Docker Compose
- AWS CLI
- Terraform

### ローカル開発環境

1. **リポジトリのクローン**
```bash
git clone https://github.com/yourusername/mysfa_rebuild.git
cd mysfa_rebuild
```

2. **Docker Composeで起動**
```bash
docker-compose up -d
```

3. **データベースマイグレーション**
```bash
docker-compose exec app python manage.py migrate
```

4. **スーパーユーザー作成**
```bash
docker-compose exec app python manage.py createsuperuser
```

5. **アプリケーションにアクセス**
```
http://localhost:8000
```

### 本番環境デプロイ

1. **Terraformでインフラ構築**
```bash
cd infrastructure
terraform init
terraform plan
terraform apply
```

2. **アプリケーションのデプロイ**
```bash
./deploy.sh
```

## 📁 プロジェクト構造

```
mysfa_rebuild/
├── src/                    # Djangoアプリケーション
│   ├── accounts/          # ユーザー管理
│   ├── mysfa/             # メインアプリケーション
│   ├── config/            # 設定ファイル
│   ├── static/            # 静的ファイル
│   ├── template/          # テンプレート
│   └── manage.py          # Django管理スクリプト
├── infrastructure/        # インフラ設定
│   ├── main.tf           # Terraform設定
│   └── variables.tf      # 変数定義
├── docker/               # Docker設定
│   └── Dockerfile        # コンテナ定義
├── .github/              # GitHub Actions
│   └── workflows/        # CI/CD設定
└── README.md             # このファイル
```

## 🔧 開発

### テスト実行
```bash
python src/manage.py test
python src/manage.py check
```

### コードフォーマット
```bash
black src/
isort src/
flake8 src/
```

### データベースリセット
```bash
python src/manage.py flush
python src/manage.py migrate
```

## 🌐 デプロイメント

### 自動デプロイ
- `main`ブランチへのプッシュで自動デプロイ
- GitHub Actionsがテスト→ビルド→デプロイを実行

### 手動デプロイ
```bash
./deploy.sh
```

## 🔒 セキュリティ

- **HTTPS**: Let's Encrypt SSL証明書
- **セキュリティヘッダー**: Django Security Middleware
- **CSRF保護**: Django CSRF Middleware
- **XSS保護**: Django XSS Protection

## 📊 監視・ログ

- **Nginx アクセスログ**: `/var/log/nginx/access.log`
- **Django アプリケーションログ**: `django.log`
- **SSL証明書**: 自動更新設定済み

## 🤝 貢献

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add some amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## 📝 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 📞 連絡先

- **GitHub**: [@yourusername](https://github.com/yourusername)
- **Email**: your.email@example.com
- **Website**: [https://mysfa.net](https://mysfa.net)

## 🙏 謝辞

- Django Community
- AWS
- Let's Encrypt
- オープンソースコミュニティ