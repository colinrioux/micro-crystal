VERSION = "1.0.0"

if GetOption("crystalfmt") == nil then
    AddOption("crystalfmt", true)
end

function onViewOpen(view)
  -- Set tabsize by default for crystal files to 2
  if CurView().Buf:FileType() == "crystal" then
    SetLocalOption("tabsize", "2", view)
  end
end

function onSave(view)
    if CurView().Buf:FileType() == "crystal" then
        if GetOption("crystalfmt") then
          format()
        end
    end
end

function crystal(a)
  local ft = CurView().Buf:FileType()
  local file = CurView().Buf.Path
  -- local args = {}
  -- for word in a:gmatch("%w+") do table.insert(args, word) end
  if a == "version" or a == "--version" or a == "-v" then
    version(args)
  elseif a == "format" then
    format()
  elseif a == "run" then
    run()
  elseif a == "build" then
    build()
  elseif a == "eval" then
    eval()
  end
end

function version(v)
  JobSpawn("crystal", {v}, "", "", "crystal.out")
end

function format()
    local ft = CurView().Buf:FileType()
    local file = CurView().Buf.Path
    CurView():Save(false)
    JobSpawn("crystal", {"tool", "format", file}, "", "", "crystal.onExit")
end

function run()
  local file = CurView().Buf.Path
  JobSpawn("crystal", {"run", file}, "", "", "crystal.out")
end

function build()
  local file = CurView().Buf.Path
  JobSpawn("crystal", {"build", file}, "", "", "crystal.out")
end

function eval()
  local ft = CurView().Buf:FileType()
  local file = CurView().Buf.Path
  local line = CurView().Buf:Line(CurView().Cursor.Y)
  JobSpawn("crystal", {"eval", line}, "", "", "crystal.out")
end

function onExit()
  CurView().Buf:ReOpen()
end

function out(output)
  messenger:Message(output)
end

function string.contains(str, word)
  return string.match(' '..str..' ', '%A'..word..'%A') ~= nil
end

function string.starts(str,start)
    return string.sub(str, 1, string.len(start)) == start
end

MakeCommand("crystal", "crystal.crystal", 0)

AddRuntimeFile("crystal", "help", "help/crystal-plugin.md")
