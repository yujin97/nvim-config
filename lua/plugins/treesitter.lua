return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local treesitter = require 'nvim-treesitter'

    local parsers = {
      'astro',
      'bash',
      'c',
      'diff',
      'html',
      'javascript',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'prisma',
      'query',
      'rust',
      'typescript',
      'vim',
      'vimdoc',
    }

    treesitter.install(parsers)

    ---@param buf integer
    ---@param language string
    local function treesitter_try_attach(buf, language)
      if not vim.treesitter.language.add(language) then
        return
      end

      vim.treesitter.start(buf, language)

      if vim.treesitter.query.get(language, 'indents') ~= nil then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.o.foldmethod = 'expr'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99

    local available_parsers = treesitter.get_available()

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('dotfiles-treesitter', { clear = true }),
      desc = 'Enable treesitter highlighting and indentation',
      callback = function(args)
        local buf, filetype = args.buf, args.match
        local language = vim.treesitter.language.get_lang(filetype)

        if not language then
          return
        end

        local installed_parsers = treesitter.get_installed 'parsers'

        if vim.tbl_contains(installed_parsers, language) then
          treesitter_try_attach(buf, language)
        elseif vim.tbl_contains(available_parsers, language) then
          treesitter.install(language):await(function()
            treesitter_try_attach(buf, language)
          end)
        else
          treesitter_try_attach(buf, language)
        end
      end,
    })
  end,
}
