VERSION = "1.0.0"


if GetOption("crystal format") == nil then
    AddOption("crystal format", false)
end

MakeCommand("crystal", "crystal.crystal", 0)

-- TODO [] Set default tab size for .cr files to 2

function onSave(view)
    if CurView().Buf:FileType() == "crystal" then
        if GetOption("crystal format") then
          format()
        end
    end
end

function format()
    local ft = CurView().Buf:FileType()
    local file = CurView().Buf.Path
    CurView():Save(false)
    JobStart("crystal tool format " .. file, "", "", "")
    CurView():ReOpen()
    
end
