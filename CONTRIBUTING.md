# Contributing to kansai_train_info

[English](CONTRIBUTING.en.md)

このプロジェクトへの貢献を検討していただきありがとうございます！

## 開発環境のセットアップ

1. リポジトリをフォーク
2. ローカルにクローン
   ```bash
   git clone https://github.com/your-username/kansai_train_info.git
   cd kansai_train_info
   ```

3. 依存関係のインストール
   ```bash
   bundle install
   ```

4. テストの実行
   ```bash
   bundle exec rspec
   ```

## 開発ガイドライン

### コーディング規約

- Rubocopのルールに従ってください
  ```bash
  bundle exec rubocop
  ```

- 型チェックを実行してください
  ```bash
  bundle exec steep check
  ```

### テスト

- 新しい機能には必ずテストを追加してください
- テストカバレッジは90%以上を維持してください
- テストは以下のコマンドで実行できます：
  ```bash
  bundle exec rspec
  ```

### コミットメッセージ

コミットメッセージは以下の形式に従ってください：

```
<type>: <subject>

<body>

<footer>
```

Type:
- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメントのみの変更
- `style`: コードの意味に影響しない変更（空白、フォーマット等）
- `refactor`: バグ修正でも機能追加でもないコードの変更
- `test`: テストの追加や修正
- `chore`: ビルドプロセスやツールの変更

### プルリクエスト

1. フィーチャーブランチを作成
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. 変更をコミット
   ```bash
   git commit -m "feat: add new feature"
   ```

3. ブランチをプッシュ
   ```bash
   git push origin feature/your-feature-name
   ```

4. GitHubでプルリクエストを作成

### プルリクエストのチェックリスト

- [ ] すべてのテストが合格している
- [ ] Rubocopの警告がない
- [ ] Steep型チェックが合格している
- [ ] テストカバレッジが90%以上
- [ ] 適切なドキュメントが追加されている
- [ ] CHANGELOGに変更内容が記載されている

## 新しい路線の追加

新しい路線を追加する場合：

1. Yahoo!路線情報から必要な情報を取得
   - エリアインデックス
   - 行インデックス
   - 詳細ID

2. `lib/kansai_train_info/client.rb`のLINESハッシュに追加：
   ```ruby
   LINES = {
     # ...
     新路線名: [area_index, row_index, detail_id]
   }
   ```

3. テストを追加
4. READMEを更新

## 問題の報告

バグを見つけた場合や機能リクエストがある場合は、[Issues](https://github.com/o8n/kansai_train_info/issues)で報告してください。

## ライセンス

このプロジェクトへの貢献は、MITライセンスの下でライセンスされることに同意したものとみなされます。