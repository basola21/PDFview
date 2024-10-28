local M = {}

function M.is_iterm2()
  return vim.env.TERM_PROGRAM == "iTerm.app"
end

function M.is_kitty()
  return vim.env.TERM == "xterm-kitty"
end

return M
