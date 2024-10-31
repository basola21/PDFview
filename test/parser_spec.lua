local parser = require("pdfview.parser")
local eq = assert.are.same -- Alias for simple assertions

describe("Parser Module", function()
	it("should return nil if PDF does not exist", function()
		local non_existent_path = "/invalid/path/to/nonexistent.pdf"
		local result = parser.extract_text(non_existent_path)
		eq(result, nil)
	end)

	it("should return text for a valid PDF file", function()
		local pdf_path = "test/files/test_pdf_with_images.pdf" -- Use an actual test file
		local result = parser.extract_text(pdf_path, 1, 1) -- Extract only first page for simplicity
		assert(result and #result > 0, "Expected non-empty text for the first page")
	end)
end)
