local parser = require('pdfview.parser')
local renderer = require('pdfview.renderer')

local M = {}

function M.open(pdf_path)
  local text = parser.extract_text(pdf_path)
  if text then
    renderer.display_text(text)
  end
end

return M
