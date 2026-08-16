# 講義・演習リンク集 セットアップ手順

移行に時間をかけないことを優先した最小構成です。以下の順に進めてください。

## 1. GitHubで新規リポジトリを作成する
- 個人アカウントで作成（大学アカウントではない）
- 公開範囲は Public を推奨（Private にする場合は GitHub Pro が必要）
- リポジトリ名は例：`biostat-course`

## 2. Quartoをローカルにインストールする
- https://quarto.org/docs/get-started/ からインストーラーを取得（Windows/Mac対応）
- インストール後、ターミナルで `quarto --version` が表示されれば完了

## 3. このテンプレート一式をリポジトリ直下に配置する
- `_quarto.yml`、`index.qmd`、`sessions/`、`data/`、`.github/workflows/publish.yml`、この`README.md` をそのままコピー

## 4. 講義回を追加する
- `sessions/01-example.qmd` を複製し、`sessions/02-〇〇.qmd` のように増やしていく
- 既存のパワーポイント・PDF・コードの内容を、該当パッケージのタブに貼り付けていくだけでよい
- 一度に全部やる必要はなく、次に教える回から順に移行すればよい

## 5. 共通データセットを配置する
- `data/` フォルダに演習用データセット（CSV等）を1箇所にまとめる
- 各 `.qmd` からは `../data/ファイル名` の形で相対参照する（パッケージ間で重複管理しない）

## 6. ローカルで見た目を確認する
- リポジトリのフォルダで `quarto preview` を実行
- ブラウザが自動で開き、サイトの見た目とタブ切り替えを確認できる

## 7. GitHubにpushする
```
git add .
git commit -m "初期セットアップ"
git push origin main
```
- push後、GitHub Actionsが自動でサイトをビルドし、GitHub Pagesに公開する
- 進捗は リポジトリの Actions タブ で確認できる（数分で完了）

## 8. 公開URLを確認してWebClassに貼る
- リポジトリの Settings → Pages で公開URLを確認
- WebClassの当該講義ページには、このURLを1本貼るだけにする
- 出席・成績管理などWebClass固有の機能はそのまま残してよい

## 異動時にやること
- このリポジトリを個人アカウントごと持っていく（GitHubは個人アカウントなのでそのまま）
- Google Driveの動画リンクも個人アカウントのため、リンク切れは発生しない
- 新しい大学のWebClass（または相当システム）に、同じ公開URLを貼り直すだけでよい
