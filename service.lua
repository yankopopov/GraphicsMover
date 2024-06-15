local M = {}


local function doesFileExistSB( fname, path )

    local results = false
   
   -- Path for the file
    local filePath = system.pathForFile( fname, path )
    print("file path is "..filePath)
    if ( filePath ) then
       local file, errorString = io.open( filePath, "r" )
   
       if not file then
           -- Error occurred; output the cause
           print( "File error: " .. errorString )
       else
           -- File exists!
           print( "File found: " .. fname )
           results = true
           -- Close the file handle
           file:close()
       end
    end
   
    return results
end
local function doesFileExist( fname, path )

    local results = false
    
    -- Path for the file
    local filePath = path..fname
    print("file path is "..filePath)
    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" )
    
        if not file then
            -- Error occurred; output the cause
            print( "File error: " .. errorString )
        else
            -- File exists!
            print( "File found: " .. fname )
            results = true
            -- Close the file handle
            file:close()
        end
    end
    
    return results
end

M.copyFileToSB = function( srcName, srcPath, dstName, dstPath, overwrite )

    local results = false
    
    local fileExists = doesFileExist( srcName, srcPath )
    if ( fileExists == false ) then
        return nil  -- nil = Source file not found
    end
    
    -- Check to see if destination file already exists
    if not ( overwrite ) then
        if ( doesFileExistSB( dstName, dstPath ) ) then
            return 1  -- 1 = File already exists (don't overwrite)
        end
    end
    
    -- Copy the source file to the destination file
    local rFilePath = srcPath..srcName  
    local wFilePath = system.pathForFile( dstName, dstPath )
    
    local rfh = io.open( rFilePath, "rb" )
    local wfh, errorString = io.open( wFilePath, "wb" )
    
    if not ( wfh ) then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Read the file and write to the destination directory
        local data = rfh:read( "*a" )
        if not ( data ) then
            print( "Read error!" )
            return false
        else
            if not ( wfh:write( data ) ) then
                print( "Write error!" )
                return false
            end
        end
    end
    
    results = 2  -- 2 = File copied successfully!
    
    -- Close file handles
    rfh:close()
    wfh:close()
    
    return results
end


M.copyFileFromSB = function( srcName, srcPath, dstName, dstPath, overwrite )

    local results = false
    
    local fileExists = doesFileExistSB( srcName, srcPath )
    if ( fileExists == false ) then
        return nil  -- nil = Source file not found
    end
    
    -- Check to see if destination file already exists
    if not ( overwrite ) then
        if ( doesFileExist( dstName, dstPath ) ) then
            return 1  -- 1 = File already exists (don't overwrite)
        end
    end
    
    -- Copy the source file to the destination file
    local rFilePath = system.pathForFile( srcName, srcPath )
    local wFilePath = dstPath..dstName
    
    local rfh = io.open( rFilePath, "rb" )
    local wfh, errorString = io.open( wFilePath, "wb" )
    
    if not ( wfh ) then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Read the file and write to the destination directory
        local data = rfh:read( "*a" )
        if not ( data ) then
            print( "Read error!" )
            return false
        else
            if not ( wfh:write( data ) ) then
                print( "Write error!" )
                return false
            end
        end
    end
    
    results = 2  -- 2 = File copied successfully!
    
    -- Close file handles
    rfh:close()
    wfh:close()
    
    return results
    end


    M.getPath=function(str,sep)
        sep=sep or'/'
        return str:match("(.*"..sep..")")
    end
    M.get_file_name=function(file)
        return file:match("^.+/(.+)$")
    end

    M.get_file_name_no_extension = function(file)
        local filename = file:match("^.+/(.+)$")
        return filename:match("(.+)%..+$")
    end

-- Touch listener for handles to resize the image
-- Function to update the size and position of the selected image based on the handle and movement


M.updateImageSizeAndPosition = function(selectedImage, resizeHandles, handle, dx, dy, proportion, shiftPressed, controlPressed)
    -- Get the rotation angle in radians
    local angle = math.rad(selectedImage.rotation)
    local cosAngle = math.cos(angle)
    local sinAngle = math.sin(angle)

    -- Calculate the local dx and dy in the rotated coordinate system
    local localDx = dx * cosAngle + dy * sinAngle
    local localDy = dy * cosAngle - dx * sinAngle

    local newWidth, newHeight

    if controlPressed then
        -- Calculate the distance from the center of the image to the mouse cursor
        local centerX, centerY = selectedImage.x, selectedImage.y
        local distanceX = (handle.startX + dx) - centerX
        local distanceY = (handle.startY + dy) - centerY

        -- Calculate the initial distances of the handle from the center
        local initialDistanceX = handle.startX - centerX
        local initialDistanceY = handle.startY - centerY

        -- Calculate the scaling factors
        local scaleX = (initialDistanceX ~= 0) and (distanceX / initialDistanceX) or 1
        local scaleY = (initialDistanceY ~= 0) and (distanceY / initialDistanceY) or 1

        -- Apply the scaling factors to calculate new width and height
        newWidth = handle.startWidth * scaleX
        newHeight = handle.startHeight * scaleY

        -- Apply proportional scaling if shift is pressed
        if shiftPressed then
            if math.abs(scaleX) > math.abs(scaleY) then
                newWidth = handle.startWidth * scaleX
                newHeight = newWidth / proportion
            else
                newHeight = handle.startHeight * scaleY
                newWidth = newHeight * proportion
            end
        end

        -- Update the position of the handle being manipulated to stay under the cursor
        handle.x = handle.startX + dx
        handle.y = handle.startY + dy

        -- Ensure consistent scaling factors
        if scaleX < 0 then
            selectedImage.xScale = -math.abs(selectedImage.xScale)
        else
            selectedImage.xScale = math.abs(selectedImage.xScale)
        end

        if scaleY < 0 then
            selectedImage.yScale = -math.abs(selectedImage.yScale)
        else
            selectedImage.yScale = math.abs(selectedImage.yScale)
        end
    else
        if handle == resizeHandles.topLeft then
            if shiftPressed then
                newWidth = handle.startWidth - localDx
                newHeight = newWidth / proportion
                localDx = handle.startWidth - newWidth
                localDy = handle.startHeight - newHeight
            else
                newWidth = handle.startWidth - localDx
                newHeight = handle.startHeight - localDy
            end
            selectedImage.x = handle.startImageX + (localDx * cosAngle - localDy * sinAngle) / 2
            selectedImage.y = handle.startImageY + (localDx * sinAngle + localDy * cosAngle) / 2
        elseif handle == resizeHandles.topRight then
            if shiftPressed then
                newWidth = handle.startWidth + localDx
                newHeight = newWidth / proportion
                localDx = newWidth - handle.startWidth
                localDy = handle.startHeight - newHeight
            else
                newWidth = handle.startWidth + localDx
                newHeight = handle.startHeight - localDy
            end
            selectedImage.x = handle.startImageX + (localDx * cosAngle - localDy * sinAngle) / 2
            selectedImage.y = handle.startImageY + (localDx * sinAngle + localDy * cosAngle) / 2
        elseif handle == resizeHandles.bottomLeft then
            if shiftPressed then
                newHeight = handle.startHeight + localDy
                newWidth = newHeight * proportion
                localDx = handle.startWidth - newWidth
                localDy = newHeight - handle.startHeight
            else
                newWidth = handle.startWidth - localDx
                newHeight = handle.startHeight + localDy
            end
            selectedImage.x = handle.startImageX + (localDx * cosAngle - localDy * sinAngle) / 2
            selectedImage.y = handle.startImageY + (localDx * sinAngle + localDy * cosAngle) / 2
        elseif handle == resizeHandles.bottomRight then
            if shiftPressed then
                newWidth = handle.startWidth + localDx
                newHeight = newWidth / proportion
                localDx = newWidth - handle.startWidth
                localDy = newHeight - handle.startHeight
            else
                newWidth = handle.startWidth + localDx
                newHeight = handle.startHeight + localDy
            end
            selectedImage.x = handle.startImageX + (localDx * cosAngle - localDy * sinAngle) / 2
            selectedImage.y = handle.startImageY + (localDx * sinAngle + localDy * cosAngle) / 2
        end
    end

    -- Apply the new dimensions
    selectedImage.width = math.abs(newWidth)
    selectedImage.height = math.abs(newHeight)
end

M.createSlider = function(options)
    -- Default options
    options = options or {}
    local width = options.width or 200
    local height = options.height or 4
    local thumbRadius = options.thumbRadius or 10
    local capRadius = height / 2
    local minValue = options.minValue or 0
    local maxValue = options.maxValue or 1  -- Ensure maxValue is 1 for alpha
    local startValue = options.startValue or 1  -- Ensure startValue is 1 for alpha
    local onChange = options.onChange or function(value) end

    -- Create slider group
    local sliderGroup = display.newGroup()

    -- Create the track
    local track = display.newRect(sliderGroup, 0, 0, width, height)
    track:setFillColor(0.8, 0.8, 0.8)
    track.anchorX = 0
    track.x = -width / 2

    -- Create the filled part of the track
    local filledTrack = display.newRect(sliderGroup, 0, 0, (startValue - minValue) / (maxValue - minValue) * width, height)
    filledTrack:setFillColor(0.3, 0.6, 0.9)
    filledTrack.anchorX = 0
    filledTrack.x = -width / 2

    -- Create the caps
    local leftCap = display.newCircle(sliderGroup, -width / 2, 0, capRadius)
    leftCap:setFillColor(0.3, 0.6, 0.9) -- same color as the filled track
    local rightCap = display.newCircle(sliderGroup, width / 2, 0, capRadius)
    rightCap:setFillColor(0.8, 0.8, 0.8)

    -- Create the thumb
    local thumb = display.newCircle(sliderGroup, 0, 0, thumbRadius * 2)
    thumb.xScale = 0.5
    thumb.yScale = 0.5
    thumb:setFillColor(0.3, 0.6, 0.9)
    thumb.x = (startValue - minValue) / (maxValue - minValue) * width - width / 2

    -- Functions to show and hide the touch overlay
    local showOverlay = function(overlay)
        transition.cancel("moveOverlay")
        transition.to(overlay, {xScale = 0.5, yScale = 0.5, time = 150, tag = "moveOverlay"})
    end

    local hideOverlay = function(overlay)
        transition.cancel("moveOverlay")
        transition.to(overlay, {xScale = 0.1, yScale = 0.1, time = 150, onComplete = function() overlay.isVisible = false end, tag = "moveOverlay"})
    end

    -- Create the touch overlay
    local touchOverlay = display.newCircle(sliderGroup, thumb.x, thumb.y, thumbRadius * 4)
    touchOverlay.xScale = 0.1
    touchOverlay.yScale = 0.1
    touchOverlay:setFillColor(0.3, 0.6, 0.9, 0.3)
    touchOverlay.isVisible = false

    -- Touch event for the thumb
    local function onThumbTouch(event)
        if event.phase == "began" then
            display.getCurrentStage():setFocus(thumb)
            thumb.isFocus = true
            touchOverlay.isVisible = true
            showOverlay(touchOverlay)
        elseif event.phase == "moved" then
            if thumb.isFocus then
                local newX = event.x - sliderGroup.x
                if newX < -width / 2 then
                    newX = -width / 2
                elseif newX > width / 2 then
                    newX = width / 2
                end
                thumb.x = newX
                touchOverlay.x = newX
                filledTrack.width = newX + width / 2
                local value = minValue + (newX + width / 2) / width * (maxValue - minValue)
                onChange(value)
            end
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.getCurrentStage():setFocus(nil)
            thumb.isFocus = nil
            hideOverlay(touchOverlay)
        end
        return true
    end

    thumb:addEventListener("touch", onThumbTouch)

    -- Function to set the slider value programmatically
    function sliderGroup:setValue(value)
        value = math.max(minValue, math.min(maxValue, value))
        thumb.x = (value - minValue) / (maxValue - minValue) * width - width / 2
        touchOverlay.x = thumb.x
        filledTrack.width = thumb.x + width / 2
        onChange(value)
    end

    -- Function to get the slider value
    function sliderGroup:getValue()
        return minValue + (thumb.x + width / 2) / width * (maxValue - minValue)
    end

    -- Initialize the slider value
    sliderGroup:setValue(startValue)

    return sliderGroup
end



return M