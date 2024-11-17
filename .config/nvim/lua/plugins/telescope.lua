return {
  "nvim-telescope/telescope.nvim",
  opts = {
    pickers = {
      find_files = {
        find_command = { "fd", "--type", "f", "--color", "never", "--hidden", "--follow", "-E", ".git" },
      },
    },
  },
}
