-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.fn.argc() ~= 0 then
      return
    end

    local ok, timer = pcall(vim.uv.new_timer)
    if not ok or not timer then
      return
    end

    local tries = 0
    local max_tries = 3
    local interval_ms = 20
    local closed = false

    local function pseudo_safe_close(t)
      if closed or not t then
        return
      end
      closed = true
      -- protect stop/close calls
      pcall(function()
        if t.is_closing then
          -- some Neovim/libuv builds expose is_closing as a method or field; try both
          local ok_, closing = pcall(function()
            return t:is_closing()
          end)
          if ok_ and closing then
            return
          end
        end
        pcall(function()
          t:stop()
        end)
        pcall(function()
          t:close()
        end)
      end)
    end

    timer:start(
      0,
      interval_ms,
      vim.schedule_wrap(function()
        tries = tries + 1
        if vim.fn.exists ':Oil' == 2 then
          pcall(function()
            vim.cmd 'Oil'
          end)

          pseudo_safe_close(timer)
          return
        end
        if tries >= max_tries then
          pseudo_safe_close(timer)
        end
      end)
    )
  end,
})
