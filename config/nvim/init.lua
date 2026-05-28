-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  DEVILSEC · neovim                                                       ║
-- ║  Sensible defaults. No plugin manager forced on the user — they can      ║
-- ║  layer lazy.nvim or LunarVim on top whenever they want.                  ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.cursorline     = true
vim.opt.termguicolors  = true
vim.opt.signcolumn     = "yes"
vim.opt.scrolloff      = 8
vim.opt.sidescrolloff  = 8
vim.opt.wrap           = false
vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.smartindent    = true
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.hlsearch       = false
vim.opt.incsearch      = true
vim.opt.splitbelow     = true
vim.opt.splitright     = true
vim.opt.mouse          = "a"
vim.opt.clipboard      = "unnamedplus"
vim.opt.undofile       = true
vim.opt.updatetime     = 250
vim.opt.timeoutlen     = 400

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ─── DEVILSEC palette ────────────────────────────────────────────────────────
local function hl(group, opts) vim.api.nvim_set_hl(0, group, opts) end
local p = {
    bg = "#0E0B12", bg_alt = "#16121C", fg = "#E8E3F2",
    fg_dim = "#807a90", violet = "#8A2BE2", crimson = "#DC2641",
    purple = "#581C87", gold = "#D4AF37", ash = "#807a90",
    green = "#7FB069", blue = "#5C5AB0", cyan = "#6FB8C9",
    ember = "#FF5E4D",
}

vim.cmd("highlight clear")
vim.opt.background = "dark"
vim.g.colors_name  = "devilsec"

hl("Normal",       { fg = p.fg,      bg = p.bg })
hl("NormalFloat",  { fg = p.fg,      bg = p.bg_alt })
hl("FloatBorder",  { fg = p.violet,  bg = p.bg_alt })
hl("CursorLine",   {                 bg = p.bg_alt })
hl("CursorLineNr", { fg = p.violet,  bold = true })
hl("LineNr",       { fg = p.fg_dim })
hl("SignColumn",   {                 bg = p.bg })
hl("VertSplit",    { fg = p.bg_alt, bg = p.bg })
hl("WinSeparator", { fg = p.violet, bg = p.bg })
hl("StatusLine",   { fg = p.fg,     bg = p.bg_alt })
hl("StatusLineNC", { fg = p.fg_dim, bg = p.bg_alt })
hl("Pmenu",        { fg = p.fg,     bg = p.bg_alt })
hl("PmenuSel",     { fg = p.bg,     bg = p.violet })
hl("Visual",       {                 bg = p.purple })
hl("Search",       { fg = p.bg,     bg = p.gold })
hl("IncSearch",    { fg = p.bg,     bg = p.crimson })
hl("MatchParen",   { fg = p.crimson, bold = true })
hl("Comment",      { fg = p.fg_dim, italic = true })
hl("Constant",     { fg = p.gold })
hl("String",       { fg = p.green })
hl("Number",       { fg = p.crimson })
hl("Boolean",      { fg = p.crimson })
hl("Function",     { fg = p.violet, bold = true })
hl("Identifier",   { fg = p.fg })
hl("Statement",    { fg = p.crimson })
hl("Keyword",      { fg = p.crimson, bold = true })
hl("PreProc",      { fg = p.violet })
hl("Type",         { fg = p.cyan })
hl("Special",      { fg = p.ember })
hl("Error",        { fg = p.ember,   bold = true })
hl("WarningMsg",   { fg = p.gold })
hl("DiagnosticError", { fg = p.crimson })
hl("DiagnosticWarn",  { fg = p.gold })
hl("DiagnosticInfo",  { fg = p.violet })
hl("DiagnosticHint",  { fg = p.cyan })

-- ─── Keymaps ─────────────────────────────────────────────────────────────────
local map = vim.keymap.set
map("n", "<leader>w", ":w<CR>",  { silent = true, desc = "write" })
map("n", "<leader>q", ":q<CR>",  { silent = true, desc = "quit" })
map("n", "<leader>e", ":Ex<CR>", { silent = true, desc = "file explorer" })
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("v", "<",  "<gv")
map("v", ">",  ">gv")
map("v", "J",  ":m '>+1<CR>gv=gv")
map("v", "K",  ":m '<-2<CR>gv=gv")

-- yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank({ higroup = "Visual", timeout = 180 }) end,
})
