return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      -- PATH 上の lldb-dap の絶対パスを取得
      local lldb_dap_path = vim.fn.exepath("lldb-dap")
      if lldb_dap_path == "" then
        lldb_dap_path = "lldb-dap" -- 見つからない場合のフォールバック
      end

      dap.adapters["lldb-dap"] = {
        type = "executable",
        command = lldb_dap_path,
        name = "lldb-dap",
      }

      local cpp_config = {
        {
          name = "lldb: デバッグ実行 (自動ビルド)",
          type = "lldb-dap",
          request = "launch",
          runInTerminal = true,
          program = function()
            local file = vim.fn.expand("%:p")
            local dir = vim.fn.expand("%:p:h")
            local outfile = dir .. "/a.out"

            local cmd = string.format(
              "clang++ -fsanitize=undefined,address -fno-sanitize-recover=all -fcolor-diagnostics -fansi-escape-codes -Wall -Wextra -Wshadow -Wno-unqualified-std-cast-call -std=gnu++2b -I include -g %s -o %s",
              vim.fn.shellescape(file),
              vim.fn.shellescape(outfile)
            )

            vim.notify("Compiling: " .. vim.fn.expand("%:t") .. " ...", vim.log.levels.INFO)
            local result = vim.fn.system(cmd)

            if vim.v.shell_error ~= 0 then
              vim.notify("Build failed:\n" .. result, vim.log.levels.ERROR)
              return nil
            end

            vim.notify("Build succeeded! Starting debugger...", vim.log.levels.INFO)
            return outfile
          end,
          cwd = function()
            return vim.fn.expand("%:p:h")
          end,
          stopOnEntry = false,
          args = {},
          env = {
            UBSAN_OPTIONS = "abort_on_error=1:print_stacktrace=1",
            ASAN_OPTIONS = "abort_on_error=1:detect_leaks=0",
          },
        },
      }

      dap.configurations.cpp = cpp_config
      dap.configurations.c = cpp_config
    end,
  },
}
