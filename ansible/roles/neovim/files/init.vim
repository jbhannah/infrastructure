call plug#begin(stdpath('data') . '/plugged')
Plug('airblade/vim-gitgutter')
Plug('blankname/vim-fish')
Plug('hashivim/vim-terraform')
Plug('hrsh7th/nvim-compe')
Plug('jiangmiao/auto-pairs')
Plug('junegunn/fzf.vim')
Plug('junegunn/vim-easy-align')
Plug('kabouzeid/nvim-lspinstall')
Plug('kaicataldo/material.vim')
Plug('kristijanhusak/vim-dadbod-ui')
Plug('neovim/nvim-lspconfig')
Plug('tpope/vim-bundler')
Plug('tpope/vim-commentary')
Plug('tpope/vim-dadbod')
Plug('tpope/vim-dispatch')
Plug('tpope/vim-endwise')
Plug('tpope/vim-fugitive')
Plug('tpope/vim-rails')
Plug('tpope/vim-repeat')
Plug('tpope/vim-rhubarb')
Plug('tpope/vim-sensible')
Plug('tpope/vim-sleuth')
Plug('tpope/vim-speeddating')
Plug('tpope/vim-surround')
Plug('tpope/vim-unimpaired')
Plug('vim-airline/vim-airline')
call plug#end()

set mouse=a
set number relativenumber

set expandtab
set shiftwidth =4
set tabstop    =4
set textwidth  =80

set background =dark
colorscheme material

if (has('termguicolors'))
  set termguicolors
endif

command! DeleteFile :call delete(expand('%')) | bdelete!

nmap <leader>sv :source $MYVIMRC<CR>

" airline
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1

" fzf
set rtp+=/usr/local/opt/fzf
nmap <C-P> :Files<CR>
let g:fzf_buffers_jump = 1

" fugitive
nmap <Leader>gs :Git<CR>
nmap <Leader>gb :Git blame<CR>

" vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" nvim-compe
set completeopt=menuone,noselect

let g:compe              = {}
let g:compe.enabled      = v:true
let g:compe.autocomplete = v:true

let g:compe.source          = {}
let g:compe.source.path     = v:true
let g:compe.source.buffer   = v:true
let g:compe.source.calc     = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true

lua <<EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD',        '<Cmd>lua vim.lsp.buf.declaration()<CR>',                                opts)
  buf_set_keymap('n', 'gd',        '<Cmd>lua vim.lsp.buf.definition()<CR>',                                 opts)
  buf_set_keymap('n', 'K',         '<Cmd>lua vim.lsp.buf.hover()<CR>',                                      opts)
  buf_set_keymap('n', 'gi',        '<cmd>lua vim.lsp.buf.implementation()<CR>',                             opts)
  buf_set_keymap('n', '<C-k>',     '<cmd>lua vim.lsp.buf.signature_help()<CR>',                             opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',                       opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',                    opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>',                            opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',                                     opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',                                opts)
  buf_set_keymap('n', 'gr',        '<cmd>lua vim.lsp.buf.references()<CR>',                                 opts)
  buf_set_keymap('n', '<space>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',               opts)
  buf_set_keymap('n', '[d',        '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',                           opts)
  buf_set_keymap('n', ']d',        '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',                           opts)
  buf_set_keymap('n', '<space>q',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',                         opts)
  buf_set_keymap("n", "<space>f",  "<cmd>lua vim.lsp.buf.formatting()<CR>",                                 opts)
end

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    nvim_lsp[server].setup{
      on_attach = on_attach
    }
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
EOF
