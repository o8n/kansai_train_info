# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Rubocop設定とコードスタイル改善
- 包括的なエラーハンドリング機能
- カスタムエラークラス（NetworkError, TimeoutError, ParseError, InvalidRouteError）
- リトライメカニズム（指数バックオフ付き）
- SimpleCovによるテストカバレッジ測定（90%以上を維持）
- RBS型定義とSteep型チェッカー
- CI/CDパイプラインの改善（CircleCI + GitHub Actions）
- Dependabot設定
- 機能拡張性の改善（設定可能なオプション、動的路線追加）

### Changed
- URI.openをNet::HTTPに置き換え（セキュリティ改善）
- Rubyの最小バージョンを3.0.0に更新
- Sorbetを削除し、RBS + Steepに移行

### Fixed
- Ruby バージョンの不整合を修正
- frozen string関連のエラーを修正

## [0.2.1] - 2020-09-10

### Fixed
- 駅名の特定に関する修正

## [0.2.0] - 2020-09-09

### Added
- 烏丸線、東西線のサポート
- テストの追加

### Fixed
- 御堂筋線の取得エラーを修正

## [0.1.0] - 2020-09-08

### Added
- 初回リリース
- 大阪環状線、近鉄京都線、阪急京都線、御堂筋線のサポート
- CLI インターフェース
- 基本的な運行情報取得機能