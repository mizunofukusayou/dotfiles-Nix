# dotfiles

macOS向けのNix (nix-darwin + home-manager) を用いたシステムおよびドットファイル設定リポジトリです。

## 1. リポジトリの準備

リポジトリをクローンし、ディレクトリに移動します。

```bash
git clone <このリポジトリのURL> dotfiles
cd dotfiles
```

## 2. Nixのインストール

Nixパッケージマネージャをインストールします。

```bash
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
```

インストール完了後、Nixのコマンドを現在のシェルで使えるようにするためにパスを通します（インストール時に表示されたコマンドを実行してください）。

```bash
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

## 3. ホスト名の設定

nix-darwinを適用するには、現在のMacの「ローカルホスト名」と、`flake.nix` 内の `darwinConfigurations` に定義している名前を一致させる必要があります。

まず、現在のMacのローカルホスト名を確認します。

```bash
scutil --get LocalHostName
```

次に `flake.nix` をエディタで開き、以下の行の `"mizunofukusayounoMacBook-Air"` の部分を、先ほど確認したローカルホスト名に変更して保存します。

```nix
darwinConfigurations."<確認したローカルホスト名>" = nix-darwin.lib.darwinSystem {
```

## 4. システム設定の適用 (初回)

初回はまだ `darwin-rebuild` や `task` コマンドがシステムにインストールされていないため、`nix run` コマンドを使って直接flakeからnix-darwinを実行し、環境を構築します。

ホスト名が一致していることを確認した上で、以下のコマンドを実行してください。

```bash
sudo nix run nix-darwin -- switch --flake .
```

## 5. 設定の再読み込みとTaskfileの利用

初回構築によって必要なパッケージ（`go-task`など）やシェル設定がインストールされます。
設定を現在のシェルに再読み込みし、今後は `task` コマンドで設定の適用（`task switch`）を行います。

```bash
. ~/.config/zsh/.zshrc
task switch
```

最後にMacを再起動することで、すべてのシステム設定が完全に反映されます。
