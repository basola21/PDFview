
# PDFview.nvim - A Neovim Plugin for Viewing PDFs

**PDFview.nvim** is a Neovim plugin designed for users who want to open, view, and navigate PDF documents directly within Neovim. It is particularly useful for those who want to integrate their workflow with Obsidian or other note-taking systems, allowing you to quickly open PDFs, extract text, and navigate through pages, all from within Neovim.

---

## Features

- **Open PDF Files**: Use Telescope to quickly search and open PDF files.
- **Extract Text**: Extract the text from a PDF using `pdftotext` for easy reading or note-taking.
- **Pagination**: Navigate through the document using next/previous page commands.
- **Customizable Pagination**: Set how many lines per page should be displayed.
- **Virtual Text Display**: See page numbers displayed in the buffer.

![Preview](https://i.imgur.com/ClDZhnc.gif)

---

## Installation

### Prerequisites

- **Neovim** version 0.5 or higher
- **Telescope.nvim**: The plugin uses Telescope to search for PDF files.
- **pdftotext**: This plugin relies on the `pdftotext` command-line tool to extract text from PDFs. Install `pdftotext` using the following command:
  ```bash
  sudo apt install poppler-utils
  ```

### Installation with LazyVim

To install `PDFview.nvim` using **LazyVim**, add the following configuration to your Neovim setup:

```lua
{
  "basola21/PDFview",
  lazy = false,
  dependencies = { "nvim-telescope/telescope.nvim" }
}
```

### Mappings

You can add the following key mappings to your Neovim configuration for easy navigation through the PDF pages:

```lua
-- Navigate to the next page in the PDF
map("n", "<leader>jj", "<cmd>:lua require('pdfview.renderer').next_page()<CR>", { desc = "PDFview: Next page" })

-- Navigate to the previous page in the PDF
map("n", "<leader>kk", "<cmd>:lua require('pdfview.renderer').previous_page()<CR>", { desc = "PDFview: Previous page" })
```

---

## Usage

1. **Opening a PDF File**  
   Use the following command to open a PDF:
   ```lua
   require('pdfview').open()
   ```
   This will open Telescope's file finder, allowing you to search for PDF files in your project or system.

2. **Navigating Pages**  
   Use the defined key mappings to navigate between pages:
   - `<leader>jj` for the next page.
   - `<leader>kk` for the previous page.

3. **Extracting Text from a PDF**  
   When you select a PDF using Telescope, the plugin extracts the text using `pdftotext` and displays it in a buffer, allowing for easy reading or note-taking.

---

## Configuration

The default lines per page are set to `50`. You can change this value by modifying the `lines_per_page` variable in the `renderer.lua` file.

---

## Planned Features

- **Improved Navigation**: Refine the pagination and scrolling behavior for a smoother reading experience.
- **Customization**: Add options for setting default configurations like `lines_per_page` and buffer options.
- **Document Search**: Implement a search feature to find specific text within the PDF.
- **Improved Structure**: Enhance the project structure for better maintainability and scalability.

---

## Contribution

Contributions are welcome! Feel free to open issues or submit pull requests to help improve the plugin.

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/my-feature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/my-feature`).
5. Open a pull request.

---

## License

This project is licensed under the MIT License.

---

## Support

If you encounter any issues or have feature requests, please open an issue in the [GitHub repository](https://github.com/basola21/PDFview).

---

Enjoy using **PDFview.nvim** for your Neovim-based PDF viewing and note-taking workflow!
