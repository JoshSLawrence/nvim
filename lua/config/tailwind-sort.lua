-- Minimal Tailwind CSS Class Sorter
-- Provides TailwindSort command without the full tailwind-tools.nvim plugin
-- Requires: tailwindcss-language-server

local M = {}

-------------------------------------------------------------------------------
-- UTILITY FUNCTIONS
-------------------------------------------------------------------------------

-- Get tailwindcss LSP client
local function get_tailwind_client()
  local clients = vim.lsp.get_clients({ name = "tailwindcss" })
  return clients[1]
end

-------------------------------------------------------------------------------
-- CLASS SORTING
-------------------------------------------------------------------------------

-- Find class attribute ranges using simple pattern matching
-- This is a simplified version that works for HTML-like files
local function find_class_ranges_simple(bufnr)
  local ranges = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for line_nr, line in ipairs(lines) do
    local row = line_nr - 1 -- Convert to 0-indexed

    -- Match className="..." 
    local s, e = line:find('className="[^"]*"')
    if s then
      local start_col = s + 10 -- Skip 'className="'
      local end_col = e - 1 -- Skip closing quote
      table.insert(ranges, { row, start_col, row, end_col })
    end
    
    -- Match className='...'
    s, e = line:find("className='[^']*'")
    if s then
      local start_col = s + 10 -- Skip "className='"
      local end_col = e - 1 -- Skip closing quote
      table.insert(ranges, { row, start_col, row, end_col })
    end
    
    -- Match class="..."
    s, e = line:find('class="[^"]*"')
    if s then
      local start_col = s + 6 -- Skip 'class="'
      local end_col = e - 1 -- Skip closing quote
      table.insert(ranges, { row, start_col, row, end_col })
    end
    
    -- Match class='...'
    s, e = line:find("class='[^']*'")
    if s then
      local start_col = s + 6 -- Skip "class='"
      local end_col = e - 1 -- Skip closing quote
      table.insert(ranges, { row, start_col, row, end_col })
    end
  end

  return ranges
end

-- Find class ranges using Treesitter (more robust)
local function find_class_ranges_treesitter(bufnr)
  local ranges = {}

  -- Check if we have treesitter parser
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then
    return find_class_ranges_simple(bufnr) -- Fallback to simple pattern
  end

  local trees = parser:parse()
  if not trees or #trees == 0 then
    return find_class_ranges_simple(bufnr)
  end

  local tree = trees[1]
  if not tree then
    return find_class_ranges_simple(bufnr)
  end

  local root = tree:root()
  local ft = vim.bo[bufnr].filetype
  
  -- Map filetypes to their treesitter parser names
  local ft_to_parser = {
    typescriptreact = "tsx",
    javascriptreact = "jsx",
  }
  
  local parser_ft = ft_to_parser[ft] or ft

  -- Try to get class query for the filetype
  local query_ok, query = pcall(vim.treesitter.query.get, parser_ft, "class")
  if not query_ok or not query then
    -- Try common parent filetypes
    local parent_fts = { "tsx", "jsx", "html" }
    for _, parent_ft in ipairs(parent_fts) do
      query_ok, query = pcall(vim.treesitter.query.get, parent_ft, "class")
      if query_ok and query then 
        break 
      end
    end
  end

  if not query then
    return find_class_ranges_simple(bufnr) -- Fallback
  end

  -- Execute query and collect ranges
  for id, node in query:iter_captures(root, bufnr) do
    local capture_name = query.captures[id]
    if capture_name == "tailwind" and node and type(node) == "userdata" then
      pcall(function()
        local s_row, s_col, e_row, e_col = node:range()
        table.insert(ranges, { s_row, s_col, e_row, e_col })
      end)
    end
  end

  -- Fallback to simple pattern if treesitter found nothing
  if #ranges == 0 then
    return find_class_ranges_simple(bufnr)
  end

  return ranges
end

-- Sort classes using tailwindcss LSP
function M.sort_classes(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local client = get_tailwind_client()
  if not client then
    vim.notify("tailwindcss-language-server not running", vim.log.levels.ERROR)
    return
  end

  -- Find all class attribute ranges
  local ranges = find_class_ranges_treesitter(bufnr)

  if #ranges == 0 then
    return -- Silently do nothing if no classes found
  end

  -- Extract class text from each range
  local class_texts = {}
  for _, range in ipairs(ranges) do
    local s_row, s_col, e_row, e_col = unpack(range)
    local text = vim.api.nvim_buf_get_text(bufnr, s_row, s_col, e_row, e_col, {})
    table.insert(class_texts, table.concat(text, "\n"))
  end

  -- Request sorting from LSP
  local params = vim.tbl_extend("error", vim.lsp.util.make_text_document_params(bufnr), {
    classLists = class_texts,
  })

  ---@diagnostic disable-next-line: param-type-mismatch
  client.request("@/tailwindCSS/sortSelection", params, function(err, result)
    if err then
      ---@diagnostic disable-next-line: need-check-nil
      vim.notify("Sort failed: " .. err.message, vim.log.levels.ERROR)
      return
    end

    if not result or not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    -- Replace each range with sorted classes
    for i, sorted_text in ipairs(result.classLists) do
      local range = ranges[i]
      local s_row, s_col, e_row, e_col = unpack(range)
      local lines = vim.split(sorted_text, "\n")

      pcall(vim.api.nvim_buf_set_text, bufnr, s_row, s_col, e_row, e_col, lines)
    end

    vim.notify("Tailwind classes sorted", vim.log.levels.INFO)
  end, bufnr)
end

-- Sort classes in visual selection
function M.sort_selection()
  local bufnr = vim.api.nvim_get_current_buf()

  local client = get_tailwind_client()
  if not client then
    vim.notify("tailwindcss-language-server not running", vim.log.levels.ERROR)
    return
  end

  -- Get visual selection range
  local s_row = vim.fn.line("'<") - 1
  local s_col = vim.fn.col("'<") - 1
  local e_row = vim.fn.line("'>") - 1
  local e_col = vim.fn.col("'>")

  -- Get selected text
  local text_lines = vim.api.nvim_buf_get_text(bufnr, s_row, s_col, e_row, e_col, {})
  local text = table.concat(text_lines, "\n")

  -- Request sorting
  local params = vim.tbl_extend("error", vim.lsp.util.make_text_document_params(bufnr), {
    classLists = { text },
  })

  ---@diagnostic disable-next-line: param-type-mismatch
  client.request("@/tailwindCSS/sortSelection", params, function(err, result)
    if err or not result then return end

    local sorted = result.classLists[1]
    local lines = vim.split(sorted, "\n")

    pcall(vim.api.nvim_buf_set_text, bufnr, s_row, s_col, e_row, e_col, lines)
  end)
end

-------------------------------------------------------------------------------
-- SETUP
-------------------------------------------------------------------------------

function M.setup()
  -- Create user commands
  vim.api.nvim_create_user_command("TailwindSort", function() M.sort_classes() end, {})
  vim.api.nvim_create_user_command("TailwindSortSelection", M.sort_selection, { range = true })
end

return M
