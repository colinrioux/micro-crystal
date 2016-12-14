VERSION = "1.0.0"


if GetOption("crystalfmt") == nil then
    AddOption("crystalfmt", false)
end

MakeCommand("crystal", "crystal.format", 0)

-- TODO [] Set default tab size for .cr files to 2

function onSave(view)
    if CurView().Buf:FileType() == "crystal" then
        if GetOption("crystalfmt") then
          format()
        end
    end
end

function format()
    local ft = CurView().Buf:FileType()
    local file = CurView().Buf.Path
    CurView():Save(false)
    JobSpawn("crystal", {"tool", "format", file}, "", "", "crystal.onExit")
end

function onExit()
  CurView().Buf:ReOpen()
end
