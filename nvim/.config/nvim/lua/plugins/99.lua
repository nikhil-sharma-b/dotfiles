return {
  "ThePrimeagen/99",
  config = function()
    local _99 = require("99")
    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)
    _99.setup({
      provider = _99.Providers.OpenCodeProvider,
      model = "gpt-5.3-codex-spark",
      logger = {
        level = _99.DEBUG,
        path = "/tmp/" .. basename .. ".99.debug",
        print_on_error = true,
      },
      tmp_dir = "./tmp",
    })

    local wk = require("which-key")
    wk.add({
      {
        mode = { "n" },
        { "<leader>p", "", desc = "+99" },
        { "<leader>ps", function() _99.search() end, desc = "99: Search" },
        { "<leader>px", function() _99.stop_all_requests() end, desc = "99: Cancel all requests" },
        { "<leader>pm", function() require("99.extensions.fzf_lua").select_model() end, desc = "99: Select model" },
        { "<leader>pp", function() require("99.extensions.fzf_lua").select_provider() end, desc = "99: Select provider" },
      },
      {
        mode = { "v" },
        { "<leader>pv", function() _99.visual() end, desc = "99: Replace selection with AI output" },
      },
    })
  end,
}
