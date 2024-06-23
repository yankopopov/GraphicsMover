local myPlugin = require("plugin.tinyfiledialogs")
local lfs = require( "lfs" )
local json = require("json")
local Service = require("service")

local M = {}

M.exportWorkspace = function(gatherImageData)
    local opts = {
        title = "Export Workspace",
        filter_patterns = "*.lua",
        filter_description = "Lua Files",
        default_path_and_file = "image_data.lua",
    }
    local exportPath = myPlugin.saveFileDialog(opts)
    if exportPath then
        local imageData = gatherImageData()
        local file = io.open(exportPath, "w")
        if file then
            file:write("return {\n")
            for _, data in ipairs(imageData) do
                file:write("    {\n")
                file:write(string.format("        y = %f,\n", data.y))
                file:write(string.format("        path = \"%s\",\n", "GFX/" .. Service.get_file_name(data.path)))
                file:write(string.format("        name = \"%s\",\n", data.name))
                file:write(string.format("        x = %f,\n", data.x))
                file:write(string.format("        height = %f,\n", data.height))
                file:write(string.format("        rotation = %d,\n", data.rotation))
                file:write(string.format("        alpha = %f,\n", data.alpha))
                file:write(string.format("        xScale = %f,\n", data.xScale))
                file:write(string.format("        yScale = %f,\n", data.yScale))
                file:write(string.format("        hierarchyIndex = %d,\n", data.hierarchyIndex))
                file:write(string.format("        width = %f\n", data.width))
                file:write("    },\n")
            end
            file:write("}\n")
            file:close()
        else
            print("Error exporting file")
        end
    end
end

M.saveWorkspace = function(gatherImageData)
    local opts = {
        title = "Save Workspace",
        filter_patterns = "*.lua",
        filter_description = "Lua Files",
        default_path_and_file = "untitled.lua",  -- Set the default file name
    }
    local savePath = myPlugin.saveFileDialog(opts)
    if savePath then
        local finalPath = Service.getPath(savePath)
        local finalFileName = Service.get_file_name(savePath)
        print("final path will be ".. finalPath)
        print("final file name will be " .. finalFileName)

        local imageData = gatherImageData()
        local serializedData = json.encode(imageData)
        timer.performWithDelay(500, function()  
            local file = io.open(savePath, "w") 

            local success = lfs.chdir( finalPath )  --returns true on success            
            if ( success ) then
                --lfs.mkdir( "MyNewBigFolder" )
            end


            --native.showAlert( "Maybe wrote", "Is this working?")
            if file then
                file:write(serializedData)
                file:close()
                native.showAlert( "I think", "we've saved the file")
                timer.performWithDelay( 500, function() end) --Service.copyFileFromSB(finalFileName, system.TemporaryDirectory, finalFileName, finalPath) end)
                
            else
                print("Error saving file")
                native.showAlert( "Error", "Error saving file")
            end                
        end )

    end
end

M.loadWorkspace = function(addImageToList, initializeImageOrder, updateImageListOrder, reorderImageGroup, imageTouch, images, imageOrder, imageGroup)
        local opts = {
            title = "Load Workspace",
            filter_patterns = "*.lua",
            filter_description = "Lua Files",
            allow_multiple_selects = false,
        }
        local loadPath = myPlugin.openFileDialog(opts)
        if loadPath then
            local file = io.open(loadPath, "r")
            if file then
                local serializedData = file:read("*a")
                file:close()
                local imageData = json.decode(serializedData)

                for _, data in ipairs(imageData) do
                    if not data.hierarchyIndex then
                        print("Error: Missing hierarchyIndex in saved data")
                        return
                    end
                end

                for _, data in ipairs(imageData) do
                    local originalPath = data.path
                    local fileName = Service.get_file_name(originalPath)
                    local tempPath = system.pathForFile(fileName, system.TemporaryDirectory)

                    Service.copyFileToSB(
                        fileName,
                        Service.getPath(originalPath),
                        fileName,
                        system.TemporaryDirectory,
                        true
                    )

                    local newImage = display.newImage(fileName, system.TemporaryDirectory)
                    newImage.x = data.x
                    newImage.y = data.y
                    newImage.width = data.width
                    newImage.height = data.height
                    newImage.rotation = data.rotation
                    newImage.alpha = data.alpha or 1
                    newImage.xScale = data.xScale or 1
                    newImage.yScale = data.yScale or 1
                    newImage.ID = os.time() + math.random(1, 1000)
                    newImage.name = data.name
                    newImage.path = originalPath
                    newImage.hierarchyIndex = data.hierarchyIndex
                    newImage:addEventListener("touch", imageTouch)
                    table.insert(images, newImage)
                    imageGroup:insert(newImage)  -- Insert into imageGroup
                    addImageToList(newImage.ID)
                end

                table.sort(images, function(a, b)
                    return a.hierarchyIndex < b.hierarchyIndex
                end)
                imageOrder = {}
                for _, img in ipairs(images) do
                    table.insert(imageOrder, img.ID)
                end

                reorderImageGroup()
                updateImageListOrder()
            else
                print("Error loading file")
            end
        end
end

return M