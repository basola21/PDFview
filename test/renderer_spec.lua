local renderer = require("pdfview.renderer")
local eq = assert.are.same

describe("Renderer Module", function()
	it("should paginate text correctly", function()
		local text = "Line 1\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6"
		local pages = renderer.paginate_text(text, 2)
		eq(#pages, 3) -- Expecting 3 pages with 2 lines each
	end)

	it("should display the first page in the buffer", function()
		local text = "Line 1\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6"
		renderer.display_text(text)
		local buf_content = vim.api.nvim_buf_get_lines(renderer.buf, 0, -1, false)
		eq(buf_content, { "Line 1", "Line 2" }) -- Expected content of the first page
	end)

	it("should navigate to the next and previous pages", function()
		local text = "Line 1\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6"
		renderer.display_text(text)
		renderer.next_page()
		local buf_content = vim.api.nvim_buf_get_lines(renderer.buf, 0, -1, false)
		eq(buf_content, { "Line 3", "Line 4" }) -- Content of the second page

		renderer.previous_page()
		buf_content = vim.api.nvim_buf_get_lines(renderer.buf, 0, -1, false)
		eq(buf_content, { "Line 1", "Line 2" }) -- Back to the first page
	end)
end)
