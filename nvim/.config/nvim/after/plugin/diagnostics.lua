-- Location information about the last message printed. The format is
-- `(did print, buffer number, line number)`.
local last_echo = { false, -1, -1 }

-- The timer used for displaying a diagnostic in the commandline.
local echo_timer = nil

-- The timer after which to display a diagnostic in the commandline.
local echo_timeout = 30

-- The highlight group to use for warning messages.
local warning_hlgroup = 'WarningMsg'

-- The highlight group to use for error messages.
local error_hlgroup = 'ErrorMsg'

-- If the first diagnostic line has fewer than this many characters, also add
-- the second line to it.
local short_line_limit = 20

-- Prints the first diagnostic for the current line.
local function echo_diagnostic()
  if echo_timer then
    echo_timer:stop()
  end

  echo_timer = vim.defer_fn(
    function()
      local line = vim.fn.line('.') - 1
      local bufnr = vim.api.nvim_win_get_buf(0)

      -- Avoid re-printing the same diagnostic if the cursor hasn't moved.
      if last_echo[1] and last_echo[2] == bufnr and last_echo[3] == line then
        return
      end

      -- Get diagnostics for the current line.
      local diags = vim.diagnostic.get(bufnr, { lnum = line, severity = { min = vim.diagnostic.severity.WARN } })

      if #diags == 0 then
        -- If we previously echo'd a message, clear it out by echoing an empty message.
        if last_echo[1] then
          last_echo = { false, -1, -1 }
          vim.api.nvim_echo({}, false, {})
        end
        return
      end

      -- Update the last echo information.
      last_echo = { true, bufnr, line }

      -- Prepare the diagnostic message.
      local diag = diags[1]
      local width = vim.api.nvim_get_option('columns') - 15
      local lines = vim.split(diag.message, "\n")
      local message = lines[1]
      local trimmed = false

      -- If the first line is too short, append the second line.
      if #lines > 1 and #message <= short_line_limit then
        message = message .. ' ' .. lines[2]
      end

      -- Trim the message if it's too long.
      if width > 0 and #message >= width then
        message = message:sub(1, width) .. '...'
      end

      -- Determine the diagnostic kind and highlight group.
      local kind = 'warning'
      local hlgroup = warning_hlgroup

      if diag.severity == vim.diagnostic.severity.ERROR then
        kind = 'error'
        hlgroup = error_hlgroup
      end

      -- Display the diagnostic message in the command line.
      local chunks = {
        { kind .. ': ', hlgroup },
        { message }
      }

      vim.api.nvim_echo(chunks, false, {})
    end,
    echo_timeout
  )
end

-- Set up an autocommand to call `echo_diagnostic` on cursor movement.
vim.api.nvim_create_autocmd('CursorMoved', {
  pattern = '*',
  callback = echo_diagnostic,
})
