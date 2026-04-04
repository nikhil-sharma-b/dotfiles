return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        golangcilint = function()
          local severities = {
            error = vim.diagnostic.severity.ERROR,
            warning = vim.diagnostic.severity.WARN,
            refactor = vim.diagnostic.severity.INFO,
            convention = vim.diagnostic.severity.HINT,
          }

          local function cmd()
            local mason_cmd = vim.fn.stdpath("data") .. "/mason/bin/golangci-lint"
            if vim.fn.executable(mason_cmd) == 1 then
              return mason_cmd
            end
            return "golangci-lint"
          end

          local function filename_modifier()
            local go_mod_location = vim.fn.system({ "go", "env", "GOMOD" })
            if vim.v.shell_error ~= 0 then
              return ":h"
            end

            go_mod_location = go_mod_location:gsub("%s+", "")
            if go_mod_location == "/dev/null" or go_mod_location == "" then
              return ":p"
            end

            return ":h"
          end

          local function args()
            local version_info = vim.fn.system({ cmd(), "version" })
            local modifier = filename_modifier()
            local file_arg = function()
              return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), modifier)
            end

            if version_info:find("version v1", 1, true) or version_info:find("version 1", 1, true) then
              return {
                "run",
                "--out-format",
                "json",
                "--issues-exit-code=0",
                "--show-stats=false",
                "--print-issued-lines=false",
                "--print-linter-name=false",
                file_arg,
              }
            end

            if version_info:find("version v2.0.", 1, true) or version_info:find("version 2.0.", 1, true) then
              return {
                "run",
                "--output.json.path=stdout",
                "--output.text.path=",
                "--output.tab.path=",
                "--output.html.path=",
                "--output.checkstyle.path=",
                "--output.code-climate.path=",
                "--output.junit-xml.path=",
                "--output.teamcity.path=",
                "--output.sarif.path=",
                "--issues-exit-code=0",
                "--show-stats=false",
                file_arg,
              }
            end

            return {
              "run",
              "--output.json.path=stdout",
              "--output.text.path=",
              "--output.tab.path=",
              "--output.html.path=",
              "--output.checkstyle.path=",
              "--output.code-climate.path=",
              "--output.junit-xml.path=",
              "--output.teamcity.path=",
              "--output.sarif.path=",
              "--issues-exit-code=0",
              "--show-stats=false",
              "--path-mode=abs",
              file_arg,
            }
          end

          return {
            cmd = cmd,
            append_fname = false,
            args = args(),
            stream = "stdout",
            parser = function(output, bufnr, cwd)
              if output == "" then
                return {}
              end

              local ok, decoded = pcall(vim.json.decode, output)
              if not ok or type(decoded) ~= "table" or type(decoded.Issues) ~= "table" then
                return {}
              end

              local diagnostics = {}
              for _, item in ipairs(decoded.Issues) do
                local curfile = vim.api.nvim_buf_get_name(bufnr)
                local curfile_abs = vim.fn.fnamemodify(curfile, ":p")
                local curfile_norm = vim.fs.normalize(curfile_abs)

                local lintedfile = cwd .. "/" .. item.Pos.Filename
                local lintedfile_abs = vim.fn.fnamemodify(lintedfile, ":p")
                local lintedfile_norm = vim.fs.normalize(lintedfile_abs)

                if curfile_norm == vim.fs.normalize(item.Pos.Filename) or curfile_norm == lintedfile_norm then
                  table.insert(diagnostics, {
                    lnum = item.Pos.Line > 0 and item.Pos.Line - 1 or 0,
                    col = item.Pos.Column > 0 and item.Pos.Column - 1 or 0,
                    end_lnum = item.Pos.Line > 0 and item.Pos.Line - 1 or 0,
                    end_col = item.Pos.Column > 0 and item.Pos.Column - 1 or 0,
                    severity = severities[item.Severity] or severities.warning,
                    source = item.FromLinter,
                    message = item.Text,
                  })
                end
              end

              return diagnostics
            end,
          }
        end,
      },
    },
  },
}
