VERSION = "1.0.0"


if GetOption("crystalfmt") == nil then
    AddOption("crystalfmt", true)
end

MakeCommand("crystaleval", "crystal.eval", 0)
MakeCommand("crystal", "crystal.crystal", 0)
-- TODO Document that crystalfmt is an option that can have crystal format
-- on save

function onViewOpen(view)
  SetLocalOption("tabsize", "2", view)
end

function onSave(view)
    if CurView().Buf:FileType() == "crystal" then
        if GetOption("crystalfmt") then
          format()
        end
    end
end

function eval(arg)
  local ft = CurView().Buf:FileType()
  local file = CurView().Buf.Path
  JobSpawn("crystal", {"eval", arg}, "", "", "crystal.out")
end

function crystal(a)
  local ft = CurView().Buf:FileType()
  local file = CurView().Buf.Path
  local args = {}
  for word in a:gmatch("%w+") do table.insert(args, word) end
  if a == "version" or a == "--version" or a == "-v" then
    version(args)
  elseif a == "format" then
    format()
  elseif a == "run" then
    run()
  elseif a == "build" then
    build()
  elseif contains(a, "eval") then
    eval(a)
  end
end

function version(args)
  JobSpawn("crystal", {args}, "", "", "crystal.out")
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

function onExit()
  CurView().Buf:ReOpen()
end

function out(output)
  messenger:Message(output)
end

function contains(str, word)
  return string.match(' '..str..' ', '%A'..word..'%A') ~= nil
end
