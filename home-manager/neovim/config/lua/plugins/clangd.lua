return {
  -- clangdの設定をカスタマイズ
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "-Iinclude", -- プロジェクトルートの include ディレクトリを追加
          },
        },
      },
    },
  },
}
