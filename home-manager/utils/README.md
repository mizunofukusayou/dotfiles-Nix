# 使い方

## snippets

`snippets.template.jsonl` を基に、`~/.config/snippets/snippets.jsonl` を作成、カスタマイズしてください。
(以下のコマンドでディレクトリ作成からリンク作成まで一発で行えます)

```bash
mkdir -p ~/.config/snippets
cp home-manager/utils/snippets.template.jsonl ~/.config/snippets/snippets.jsonl
ln -s ~/.config/snippets/snippets.jsonl home-manager/utils/snippets.jsonl
```
