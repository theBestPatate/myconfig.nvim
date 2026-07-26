-- diagnostics visual test — run :DiagDemo to populate
--
-- After running the command, you should see:
--   ┌ Error line   → wavy undercurl (~~~~) in coral
--   ├ Warning line → dashed underline (----) in amber
--   ├ Info line    → dotted underline (····) in slate blue
--   ├ Hint line    → dotted underline (····) in gray-purple
--   └ Ok line      → no underline at all
--
-- Compare the different underline styles to see how granular
-- diagnostic styling works in chilling-potato.

local function error_example()
  local x = nil
  return x.field  -- ERROR: accessing nil
end

local function warning_example()
  local unused = "this variable is never used"
  return true
end

local function info_example()
  -- This function could be optimized
  local result = 0
  for i = 1, 10 do result = result + i end
  return result
end

local function hint_example()
  local x = "hello"
  -- consider using single quotes
  return x
end

local function ok_example()
  -- this function is perfectly fine
  return 42
end
