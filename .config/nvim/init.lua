-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
--
vim.cmd([[
  set tabstop=4
  set shiftwidth=4
  set softtabstop=4
  set expandtab

  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]])
