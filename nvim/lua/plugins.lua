function setup_lspconfig()
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    local on_attach = function(client)
        require("completion").on_attach(client)
    end

    require('lspconfig').clangd.setup{ capabilities = capabilities }
    require('lspconfig').gopls.setup{ capabilities = capabilities }
    require('lspconfig').pylsp.setup{ capabilities = capabilities }
    require('lspconfig').rls.setup{ capabilities = capabilities }
    require('lspconfig').rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importGranularity = "module",
                    importPrefix = "by_self",
                },
                cargo = {
                    loadOutDirsFromCheck = true
                },
                procMacro = {
                    enable = true
                },
            },
        },
    })
end

function setup_treesitter()
    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            "c",
            "cpp",
            "go",
            "json",
            "lua",
            "python",
            "rust",
            "toml",
            "yaml"
        },
        ignore_install = { },
        highlight = {
            enable = true,
            disable = { },
            additional_vim_regex_highlighting = false,
        },
    }
end

function setup_lualine()
    require('lualine').setup {
        options = {
            icons_enabled = false,
            theme = 'palenight',
            section_separators = '',
            component_separators = '|',
        },
        sections = {
            lualine_b = {{'branch', color = {fg = '#bfc7d5'}}},
            lualine_c = {{'filename', color = {fg = '#bfc7d5'}}},
            lualine_x = {
                {'encoding', color = {fg = '#bfc7d5'}},
                {'fileformat', color = {fg = '#bfc7d5'}},
                {'filetype', color = {fg = '#bfc7d5'}},
            },
            lualine_y = {{'progress', color = {fg = '#bfc7d5', bg='#be5046'}}},
            lualine_z = {{'location', color = {fg = '#292d3e', bg='#ffcb6b'}}}
        }
    }
end

function setup_lspsaga()
    require('lspsaga').init_lsp_saga {
        error_sign = 'E',
        warn_sign = 'W',
        hint_sign = 'H',
        infor_sign = 'I',
        code_action_icon = '!',
    }

    vim.api.nvim_set_keymap("n", "<leader>gh",
        [[<cmd>lua require('lspsaga.provider').lsp_finder()<CR>]],
        { noremap = true, silent = true}
        )
    vim.api.nvim_set_keymap("n", "<leader>ca",
        [[<cmd>lua require('lspsaga.codeaction').code_action()<CR>]],
        { noremap = true, silent = true}
        )
    vim.api.nvim_set_keymap("n", "K",
        [[<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>]],
        { noremap = true, silent = true}
        )
    vim.api.nvim_set_keymap("n", "<C-f>",
        [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>]],
        { noremap = true, silent = true}
        )
    vim.api.nvim_set_keymap("n", "<C-b>",
        [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>]],
        { noremap = true, silent = true}
        )
    vim.api.nvim_set_keymap("n", "<leader>gs",
        [[<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>]],
        { noremap = true, silent = true}
        )
    vim.api.nvim_set_keymap("n", "<leader>gr",
        [[<cmd>lua require('lspsaga.rename').rename()<CR>]],
        { noremap = true, silent = true}
        )
    vim.api.nvim_set_keymap("n", "<leader>gd",
        [[<cmd>lua require('lspsaga.provider').preview_definition()<CR>]],
        { noremap = true, silent = true}
        )
    vim.api.nvim_set_keymap("n", "<leader>cd",
        [[<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>]],
        { noremap = true, silent = true}
        )
    vim.api.nvim_set_keymap("n", "<C-j>",
        [[<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>]],
        { noremap = true, silent = true}
        )
    vim.api.nvim_set_keymap("n", "<C-k>",
        [[<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>]],
        { noremap = true, silent = true}
        )
end

function setup_kommentary()
    vim.g.kommentary_create_default_mappings = false
    require('kommentary.config').configure_language("default", {
            use_consistent_indentation = true,
        })

    vim.api.nvim_set_keymap("n", "<leader>cc", "<Plug>kommentary_line_increase", {})
    vim.api.nvim_set_keymap("n", "<leader>ci", "<Plug>kommentary_motion_increase", {})
    vim.api.nvim_set_keymap("x", "<leader>cc", "<Plug>kommentary_visual_increase", {})
    vim.api.nvim_set_keymap("n", "<leader>cu", "<Plug>kommentary_line_decrease", {})
    vim.api.nvim_set_keymap("n", "<leader>cd", "<Plug>kommentary_motion_decrease", {})
    vim.api.nvim_set_keymap("x", "<leader>cu", "<Plug>kommentary_visual_decrease", {})
end

function setup_vista()
    vim.g['vista#renderer#enable_icon'] = 0
    vim.g.vista_icon_indent = {">", ""}
    vim.g.vista_sidebar_position = 'vertical topleft'
    vim.g.vista_close_on_jump = 1
    vim.api.nvim_set_keymap("n", "<leader>v", ":Vista!!<CR>", {})
end

function setup_nvimtree()
    require('nvim-tree').setup {}
    vim.g.nvim_tree_quit_on_open = 1
    vim.g.nvim_tree_indent_markers = 1
    vim.api.nvim_set_keymap("n", "<leader>n", ":NvimTreeToggle<CR>", {})
    vim.api.nvim_set_keymap("n", "<leader>nr", ":NvimTreeRefresh<CR>", {})
    vim.api.nvim_set_keymap("n", "<leader>nf", ":NvimTreeFindFile<CR>", {})
end

function setup_buffergator()
    vim.g.buffergator_viewport_split_policy = "T"
    vim.g.buffergator_hsplit_size = 10
end

function setup_sneak()
    vim.g['sneak#label'] = 1
end

function setup_ale()
    vim.g.ale_rust_cargo_use_check = 1
end

function setup_doge()
    vim.g.doge_doc_standard_python = 'google'
end

function setup_vsnip()
end

function setup_nvim_cmp()
    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end

	local cmp = require('cmp')
    cmp.setup {
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        mapping = {
            ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<C-y>'] = cmp.config.disable,
            ['<C-e>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn["vsnip#available"](1) == 1 then
                    feedkey("<Plug>(vsnip-expand-or-jump)", "")
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.fn["vim#jumpable"](-1) == 1 then
                    feedkey("<Plug>(vsnip-jump-prev)", "")
                end
            end, { 'i', 's' }),
        },
        sources = cmp.config.sources({
            { name = 'vsnip' },
            { name = 'nvim_lsp', max_item_count = 20 },
            { name = 'path' },
            { name = 'buffer' },
        })
	}
end

return require('packer').startup(function()
    -- Packer managing itself
    use { 'wbthomason/packer.nvim' }

    -- Fugitive
    use { 'tpope/vim-fugitive' }

    -- lualine
    use { 'hoob3rt/lualine.nvim', config = setup_lualine, }

    -- nvim-lspconfig
    use { 'neovim/nvim-lspconfig', config = setup_lspconfig, }

    -- nvim-cmp
	use { 'hrsh7th/cmp-nvim-lsp' }
	use { 'hrsh7th/cmp-buffer' }
	use { 'hrsh7th/cmp-path' }
	use { 'hrsh7th/nvim-cmp', config = setup_nvim_cmp, }

    -- Treesitter
    use { 'nvim-treesitter/nvim-treesitter', config = setup_treesitter,  }

    -- palenight
    use { 'drewtempelmeyer/palenight.vim' }

    -- lspsaga
    use { 'tami5/lspsaga.nvim', branch = 'nvim6.0', config = setup_lspsaga }

    -- polyglot
    use { 'sheerun/vim-polyglot' }

    -- sneak
    use { 'justinmk/vim-sneak', config = setup_sneak, }

    -- vista/ctags
    use { 'liuchengxu/vista.vim', config = setup_vista, }

    -- kommentary
    use { 'b3nj5m1n/kommentary', config = setup_kommentary, }

    -- buffergator
    use { 'jeetsukumaran/vim-buffergator', config = setup_buffergator, }

    -- nvim-tree
    use { 'kyazdani42/nvim-tree.lua', config = setup_nvimtree, }

    -- ALE
    use { 'dense-analysis/ale', config = setup_ale }

    -- DoGe
    use { 'kkoomen/vim-doge', config = setup_doge }

    -- Snippets
    use { 'hrsh7th/cmp-vsnip' }
    use {
        'hrsh7th/vim-vsnip' ,
        requires = {
            { "hrsh7th/vim-vsnip-integ", after = "vim-vsnip" },
            { 'rafamadriz/friendly-snippets', after = "vim-vsnip" },
        }
    }
end)
