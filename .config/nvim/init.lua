-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, { "NormalFloat", "NvimTreeNormal" })
vim.o.langmap =
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
