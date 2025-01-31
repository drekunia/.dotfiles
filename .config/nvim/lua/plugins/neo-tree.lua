return {
  "neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        --visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        --hide_by_name = {
        --  ".github",
        --  ".gitignore",
        --  "package-lock.json",
        --},
        never_show = { ".git" },
      },
    },
    window = {
      position = "right",
    },
  },
}
