return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                -- Add globals you want to silence warnings for
                -- globals = { "vim", "use" },
                -- Optionally disable the warning entirely
                disable = { "undefined-global" },
              },
            },
          },
        },
      },
    },
  },
}
