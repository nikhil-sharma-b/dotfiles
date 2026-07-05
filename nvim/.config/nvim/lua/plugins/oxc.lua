-- Project-local oxfmt (formatter) and oxlint (linter) support.
-- Only activates when .oxfmtrc.json / .oxlintrc.json exist in the project root.
return {
  -- oxfmt via conform.nvim (not built-in yet, so we define a custom formatter)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "oxfmt", "prettier" },
        javascriptreact = { "oxfmt", "prettier" },
        typescript = { "oxfmt", "prettier" },
        typescriptreact = { "oxfmt", "prettier" },
        json = { "oxfmt", "prettier" },
      },
      formatters = {
        oxfmt = {
          command = "oxfmt",
          args = { "$FILENAME" },
          cwd = require("conform.util").root_file({ ".oxfmtrc.json" }),
          require_cwd = true,
        },
      },
    },
  },

  -- oxlint via nvim-lint
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "oxlint" },
        javascriptreact = { "oxlint" },
        typescript = { "oxlint" },
        typescriptreact = { "oxlint" },
      },
      linters = {
        oxlint = {
          condition = function(ctx)
            return vim.fs.find(".oxlintrc.json", { path = ctx.filename, upward = true })[1] ~= nil
          end,
        },
      },
    },
  },
}
