local M = {}

-- State to keep track of pages
local state = {
  current_page = 1,
  total_pages = 0,
  pages = {},
}

-- Function to display the current page
function M.display_current_page()
  local buf = state.buf

  -- Set buffer to modifiable before making changes
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
  -- Clear existing buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

  -- Get the lines for the current page
  local page_lines = state.pages[state.current_page]

  -- Set the lines in the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, page_lines)

  -- Set buffer back to non-modifiable
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

  -- Update statusline or virtual text with page information
  M.update_page_info()
end

-- Function to update page information
function M.update_page_info()
  local buf = state.buf
  local page_info = string.format("Page %d/%d", state.current_page, state.total_pages)

  -- Set virtual text at the end of the buffer
  vim.api.nvim_buf_clear_namespace(buf, state.ns_id, 0, -1)
  vim.api.nvim_buf_set_extmark(buf, state.ns_id, 0, 0, {
    virt_text = { { page_info, "Comment" } },
    virt_text_pos = "right_align",
  })
end

-- Function to split text into pages
function M.paginate_text(text, lines_per_page)
  local lines = vim.split(text, "\n")
  local pages = {}
  for i = 1, #lines, lines_per_page do
    local page = vim.list_slice(lines, i, i + lines_per_page - 1)
    table.insert(pages, page)
  end
  return pages
end

-- Function to initialize the buffer and display the first page
function M.display_text(text)
  -- Default lines per page
  local lines_per_page = 50 -- You can make this configurable

  -- Split text into pages
  state.pages = M.paginate_text(text, lines_per_page)
  state.total_pages = #state.pages
  state.current_page = 1

  -- Create a new buffer or reuse existing one
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
  end
  local buf = state.buf

  -- Set buffer-local options using nvim_set_option_value
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
  vim.api.nvim_set_option_value("filetype", "pdfview", { buf = buf })

  state.ns_id = vim.api.nvim_create_namespace("PDFview")

  -- Display the current page
  M.display_current_page()

  -- Open a new window with the buffer
  vim.api.nvim_set_current_buf(buf)

  -- Set up key mappings for navigation
  M.setup_keymaps(buf)
end

-- Function to go to the next page
function M.next_page()
  if state.current_page < state.total_pages then
    state.current_page = state.current_page + 1
    M.display_current_page()
  else
    vim.api.nvim_echo({ { "PDFview: Already at the last page.", "WarningMsg" } }, false, {})
  end
end

-- Function to go to the previous page
function M.previous_page()
  if state.current_page > 1 then
    state.current_page = state.current_page - 1
    M.display_current_page()
  else
    vim.api.nvim_echo({ { "PDFview: Already at the first page.", "WarningMsg" } }, false, {})
  end
end

return M
