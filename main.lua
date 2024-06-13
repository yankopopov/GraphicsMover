-----------------------------------------------------------------------------------------
-- main.lua
-----------------------------------------------------------------------------------------
local json = require("json")
-- Set up display width and height
_W = display.contentWidth
_H = display.contentHeight

-- Create display groups
local imageGroup = display.newGroup()
local handleGroup = display.newGroup()
local uiGroup = display.newGroup()

-- Ensure the UI group is above the image group
uiGroup:toFront()

-- State variable to track which button is selected
local selectedButton = "resize" -- Resize button selected by default
local removeHandles, showHandles, updateHandles, updateTextColors, moveImageUp, 
moveImageDown, deleteImage, selectedImage, ButtonRotate, ButtonResize,
moveImageToTop, moveImageToBottom, saveWorkspace, loadWorkspace;
local images = {}
local handles = {}
local resizeHandles = {}
local rotateHandles = {}
local createdImmages = 0


-- Event listener for ButtonUp
local function onButtonUpTouch(event)
    local self = event.target
    local InitialScaleX = self.InitialScaleX
    local InitialScaleY = self.InitialScaleY
    if event.phase == "began" then
        display.getCurrentStage():setFocus(self, event.id)
        self.xScale = InitialScaleX - 0.05
        self.yScale = InitialScaleY - 0.05
        self.isFocus = true
    elseif self.isFocus then
        if event.phase == "ended" or event.phase == "cancelled" then
            self.xScale = InitialScaleX
            self.yScale = InitialScaleY
            display.getCurrentStage():setFocus(self, nil)
            self.isFocus = false
            if selectedImage then
                moveImageUp(selectedImage.ID)
            end
        end
    end 
    return true
end
local function onButtonToBottomTouch(event)
    local self = event.target
    local InitialScaleX = self.InitialScaleX
    local InitialScaleY = self.InitialScaleY
    if event.phase == "began" then
        display.getCurrentStage():setFocus(self, event.id)
        self.xScale = InitialScaleX - 0.05
        self.yScale = InitialScaleY - 0.05
        self.isFocus = true
    elseif self.isFocus then
        if event.phase == "ended" or event.phase == "cancelled" then
            self.xScale = InitialScaleX
            self.yScale = InitialScaleY
            display.getCurrentStage():setFocus(self, nil)
            self.isFocus = false
            if selectedImage then
                moveImageToBottom(selectedImage.ID)
            end
        end
    end 
    return true
end
local function onButtonToTopTouch(event)
    local self = event.target
    local InitialScaleX = self.InitialScaleX
    local InitialScaleY = self.InitialScaleY
    if event.phase == "began" then
        display.getCurrentStage():setFocus(self, event.id)
        self.xScale = InitialScaleX - 0.05
        self.yScale = InitialScaleY - 0.05
        self.isFocus = true
    elseif self.isFocus then
        if event.phase == "ended" or event.phase == "cancelled" then
            self.xScale = InitialScaleX
            self.yScale = InitialScaleY
            display.getCurrentStage():setFocus(self, nil)
            self.isFocus = false
            if selectedImage then
                moveImageToTop(selectedImage.ID)
            end
        end
    end 
    return true
end

local function onButtonDownTouch(event)
    local self = event.target
    local InitialScaleX = self.InitialScaleX
    local InitialScaleY = self.InitialScaleY
    if event.phase == "began" then
        display.getCurrentStage():setFocus(self, event.id)
        self.xScale = InitialScaleX - 0.05
        self.yScale = InitialScaleY - 0.05
        self.isFocus = true
    elseif self.isFocus then
        if event.phase == "ended" or event.phase == "cancelled" then
            self.xScale = InitialScaleX
            self.yScale = InitialScaleY
            display.getCurrentStage():setFocus(self, nil)
            self.isFocus = false
            if selectedImage then
                moveImageDown(selectedImage.ID)
            end
        end
    end 
    return true
end

-- Function to set button tint
local function setButtonTint(button, isSelected)
    if isSelected then
        button:setFillColor(1, 0, 0) -- Red tint
    else
        button:setFillColor(1, 1, 1) -- Neutral tint
    end
end

-- Function to change handles when button is pressed
local function updateHandlesForm()
    if selectedImage then
        removeHandles()
        showHandles()
    end
end

-- Event listener for ButtonResize
local function onButtonResizeTouch(event)
    if event.phase == "ended" then
        if selectedButton == "resize" then
            selectedButton = nil
            setButtonTint(ButtonResize, false)
        else
            selectedButton = "resize"
            setButtonTint(ButtonResize, true)
            setButtonTint(ButtonRotate, false)
            updateHandlesForm()
            updateHandles()
        end
    end
    return true
end

-- Event listener for ButtonRotate
local function onButtonRotateTouch(event)
    if event.phase == "ended" then
        if selectedButton == "rotate" then
            selectedButton = nil
            setButtonTint(ButtonRotate, false)
        else
            selectedButton = "rotate"
            setButtonTint(ButtonRotate, true)
            setButtonTint(ButtonResize, false)
            updateHandlesForm()
        end
    end
    return true
end


local function onButtonSaveTouch(event)
    local self = event.target
    local InitialScaleX = self.InitialScaleX
    local InitialScaleY = self.InitialScaleY
    if event.phase == "began" then
        display.getCurrentStage():setFocus(self, event.id)
        self.xScale = InitialScaleX - 0.05
        self.yScale = InitialScaleY - 0.05
        self.isFocus = true
    elseif self.isFocus then
        if event.phase == "ended" or event.phase == "cancelled" then
            self.xScale = InitialScaleX
            self.yScale = InitialScaleY
            display.getCurrentStage():setFocus(self, nil)
            self.isFocus = false
            saveWorkspace()
        end
    end 
    return true
end
local function onButtonLoadTouch(event)
    local self = event.target
    local InitialScaleX = self.InitialScaleX
    local InitialScaleY = self.InitialScaleY
    if event.phase == "began" then
        display.getCurrentStage():setFocus(self, event.id)
        self.xScale = InitialScaleX - 0.05
        self.yScale = InitialScaleY - 0.05
        self.isFocus = true
    elseif self.isFocus then
        if event.phase == "ended" or event.phase == "cancelled" then
            self.xScale = InitialScaleX
            self.yScale = InitialScaleY
            display.getCurrentStage():setFocus(self, nil)
            self.isFocus = false
            loadWorkspace()
        end
    end 
    return true
end


-- top buttons
ButtonSave = display.newImage("GFX/save.png")
ButtonSave.xScale = 0.3
ButtonSave.yScale = 0.3
ButtonSave.InitialScaleX = ButtonSave.xScale
ButtonSave.InitialScaleY = ButtonSave.yScale
ButtonSave.x = 20
ButtonSave.y = 20
ButtonSave:addEventListener("touch", onButtonSaveTouch)

ButtonLoad = display.newImage("GFX/load.png")
ButtonLoad.xScale = 0.3
ButtonLoad.yScale = 0.3
ButtonLoad.InitialScaleX = ButtonLoad.xScale
ButtonLoad.InitialScaleY = ButtonLoad.yScale
ButtonLoad.x = 53
ButtonLoad.y = 20
ButtonLoad:addEventListener("touch", onButtonLoadTouch)

ButtonResize = display.newImage("GFX/resize.png")
ButtonResize.xScale = 0.3
ButtonResize.yScale = 0.3
ButtonResize.x = _W / 2 - 30
ButtonResize.y = 20
ButtonResize:addEventListener("touch", onButtonResizeTouch)

ButtonRotate = display.newImage("GFX/rotate.png")
ButtonRotate.xScale = 0.3
ButtonRotate.yScale = 0.3
ButtonRotate.x = _W / 2 + 3
ButtonRotate.y = 20
ButtonRotate:addEventListener("touch", onButtonRotateTouch)

ButtonToTop = display.newImage("GFX/totop.png")
ButtonToTop.xScale = 0.3
ButtonToTop.yScale = 0.3
ButtonToTop.InitialScaleX = ButtonToTop.xScale
ButtonToTop.InitialScaleY = ButtonToTop.yScale
ButtonToTop.x = _W -285
ButtonToTop.y = 20
ButtonToTop:addEventListener("touch", onButtonToTopTouch)

ButtonDown = display.newImage("GFX/up_arrow.png")
ButtonDown.xScale = 0.3
ButtonDown.yScale = 0.3
ButtonDown.InitialScaleX = ButtonDown.xScale
ButtonDown.InitialScaleY = ButtonDown.yScale
ButtonDown.x = _W - 252
ButtonDown.y = 20
ButtonDown:addEventListener("touch", onButtonDownTouch)

ButtonUp = display.newImage("GFX/down_arrow.png")
ButtonUp.xScale = 0.3
ButtonUp.yScale = 0.3
ButtonUp.InitialScaleX = ButtonUp.xScale
ButtonUp.InitialScaleY = ButtonUp.yScale
ButtonUp.x = _W -219
ButtonUp.y = 20
ButtonUp:addEventListener("touch", onButtonUpTouch)

ButtonToBottom = display.newImage("GFX/tobottom.png")
ButtonToBottom.xScale = 0.3
ButtonToBottom.yScale = 0.3
ButtonToBottom.InitialScaleX = ButtonToBottom.xScale
ButtonToBottom.InitialScaleY = ButtonToBottom.yScale
ButtonToBottom.x = _W -186
ButtonToBottom.y = 20
ButtonToBottom:addEventListener("touch", onButtonToBottomTouch)

ButtonAddNew = display.newImage("GFX/addnew.png")
ButtonAddNew.xScale = 0.3
ButtonAddNew.yScale = 0.3
ButtonAddNew.x = _W - 285
ButtonAddNew.y = _H - 20


-- Add other UI elements (buttons, etc.) to the uiGroup
uiGroup:insert(ButtonResize)
uiGroup:insert(ButtonRotate)
uiGroup:insert(ButtonUp)
uiGroup:insert(ButtonDown)
uiGroup:insert(ButtonResize)
uiGroup:insert(ButtonRotate)
uiGroup:insert(ButtonToTop)
uiGroup:insert(ButtonToBottom)


-- Set initial tint for buttons
setButtonTint(ButtonResize, true)
setButtonTint(ButtonRotate, false)
setButtonTint(ButtonUp, false)
setButtonTint(ButtonDown, false)

-- Create a display group for the button drawer
local myPlugin = require("plugin.tinyfiledialogs")
local Service = require("service")


-- Initialize visibility and movement variables
local visible = false


-- Track the state of the shift key
local shiftPressed = false
local controlPressed = false

-- Key event listener to track shift key state
local function onKeyEvent(event)
    if event.keyName == "leftShift" or event.keyName == "rightShift" then
        if event.phase == "down" then
            shiftPressed = true
        elseif event.phase == "up" then
            shiftPressed = false
        end
    end
    if event.keyName == "leftControl" or event.keyName == "rightControl" then
        if event.phase == "down" then
            controlPressed = true
        elseif event.phase == "up" then
            controlPressed = false
        end
    end
    return false
end

Runtime:addEventListener("key", onKeyEvent)

-- Function to create handles for resizing the image
local function createHandle(x, y)
    local handle
    if selectedButton == "rotate" then
        handle = display.newCircle(x, y, 5)
        handle:setFillColor(1, 0, 0, 0.7)
    else
        handle = display.newRect(x, y, 10, 10)
        handle:setFillColor(0, 1, 0, 0.7)
    end
    handleGroup:insert(handle)
    handle:toFront()
    return handle
end

-- Function to update handle positions based on the image size, position, and rotation
updateHandles = function()
    if selectedImage then
        local halfWidth = selectedImage.width / 2
        local halfHeight = selectedImage.height / 2
        local cosRot = math.cos(math.rad(selectedImage.rotation))
        local sinRot = math.sin(math.rad(selectedImage.rotation))

        local function getRotatedPosition(x, y)
            return {
                x = selectedImage.x + (x * cosRot - y * sinRot),
                y = selectedImage.y + (x * sinRot + y * cosRot)
            }
        end

        if selectedButton == "resize" then
            local topLeft = getRotatedPosition(-halfWidth, -halfHeight)
            local topRight = getRotatedPosition(halfWidth, -halfHeight)
            local bottomLeft = getRotatedPosition(-halfWidth, halfHeight)
            local bottomRight = getRotatedPosition(halfWidth, halfHeight)

            resizeHandles.topLeft.x, resizeHandles.topLeft.y = topLeft.x, topLeft.y
            resizeHandles.topRight.x, resizeHandles.topRight.y = topRight.x, topRight.y
            resizeHandles.bottomLeft.x, resizeHandles.bottomLeft.y = bottomLeft.x, bottomLeft.y
            resizeHandles.bottomRight.x, resizeHandles.bottomRight.y = bottomRight.x, bottomRight.y
        elseif selectedButton == "rotate" then
            local topLeft = getRotatedPosition(-halfWidth, -halfHeight)
            local topRight = getRotatedPosition(halfWidth, -halfHeight)
            local bottomLeft = getRotatedPosition(-halfWidth, halfHeight)
            local bottomRight = getRotatedPosition(halfWidth, halfHeight)

            rotateHandles.topLeft.x, rotateHandles.topLeft.y = topLeft.x, topLeft.y
            rotateHandles.topRight.x, rotateHandles.topRight.y = topRight.x, topRight.y
            rotateHandles.bottomLeft.x, rotateHandles.bottomLeft.y = bottomLeft.x, bottomLeft.y
            rotateHandles.bottomRight.x, rotateHandles.bottomRight.y = bottomRight.x, bottomRight.y
        end
    end
end

local HandleScale = 1.8
-- Touch listener for handles to resize or rotate the image
local function handleTouch(event)
    local handle = event.target
    if event.phase == "began" then
        display.getCurrentStage():setFocus(handle, event.id)
        handle.isFocus = true
        handle.startX, handle.startY = event.x, event.y
        handle.startWidth, handle.startHeight = selectedImage.width, selectedImage.height
        handle.startImageX, handle.startImageY = selectedImage.x, selectedImage.y
        handle.startRotation = selectedImage.rotation
        handle:scale(HandleScale, HandleScale) -- Scale up the handle being dragged
    elseif handle.isFocus then
        if event.phase == "moved" then
            local dx, dy = event.x - handle.startX, event.y - handle.startY
            if selectedButton == "resize" then
                local proportion = handle.startWidth / handle.startHeight

                Service.updateImageSizeAndPosition(
                    selectedImage,
                    resizeHandles,
                    handle,
                    dx,
                    dy,
                    proportion,
                    shiftPressed,
                    controlPressed
                )
                updateHandles()
            elseif selectedButton == "rotate" then
                local imageCenterX, imageCenterY = selectedImage.x, selectedImage.y
                local startAngle = math.atan2(handle.startY - imageCenterY, handle.startX - imageCenterX)
                local currentAngle = math.atan2(event.y - imageCenterY, event.x - imageCenterX)
                local angleDelta = math.deg(currentAngle - startAngle)
                selectedImage.rotation = handle.startRotation + angleDelta
                updateHandles()
            end
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.getCurrentStage():setFocus(handle, nil)
            handle.isFocus = false
            handle:scale(1 / HandleScale, 1 / HandleScale) -- Scale back the handle to its original size
        end
    end
    return true
end

-- Function to add touch listeners to handles
local function addHandleListeners()
    for _, handle in pairs(handles) do
        handle:addEventListener("touch", handleTouch)
    end
end

-- Function to remove handles from the display
removeHandles = function()
    print "will remove handles"
    for _, handle in pairs(resizeHandles) do
        handle:removeSelf()
    end
    resizeHandles = {}
    for _, handle in pairs(rotateHandles) do
        handle:removeSelf()
    end
    rotateHandles = {}
end

-- Function to create and show handles around the selected image
showHandles = function()
    if selectedImage then
        if selectedButton == "resize" then
            -- Create resize handles (ignoring rotation)
            resizeHandles = {
                topLeft = createHandle(
                    selectedImage.x - selectedImage.width / 2,
                    selectedImage.y - selectedImage.height / 2
                ),
                topRight = createHandle(
                    selectedImage.x + selectedImage.width / 2,
                    selectedImage.y - selectedImage.height / 2
                ),
                bottomLeft = createHandle(
                    selectedImage.x - selectedImage.width / 2,
                    selectedImage.y + selectedImage.height / 2
                ),
                bottomRight = createHandle(
                    selectedImage.x + selectedImage.width / 2,
                    selectedImage.y + selectedImage.height / 2
                )
            }

            -- Add touch listeners to resize handles
            for _, handle in pairs(resizeHandles) do
                handle:addEventListener("touch", handleTouch)
            end
        elseif selectedButton == "rotate" then
            -- Create rotation handles
            local halfWidth = selectedImage.width / 2
            local halfHeight = selectedImage.height / 2
            local cosRot = math.cos(math.rad(selectedImage.rotation))
            local sinRot = math.sin(math.rad(selectedImage.rotation))

            local function getRotatedPosition(x, y)
                return {
                    x = selectedImage.x + (x * cosRot - y * sinRot),
                    y = selectedImage.y + (x * sinRot + y * cosRot)
                }
            end

            local topLeft = getRotatedPosition(-halfWidth, -halfHeight)
            local topRight = getRotatedPosition(halfWidth, -halfHeight)
            local bottomLeft = getRotatedPosition(-halfWidth, halfHeight)
            local bottomRight = getRotatedPosition(halfWidth, halfHeight)

            rotateHandles = {
                topLeft = createHandle(topLeft.x, topLeft.y),
                topRight = createHandle(topRight.x, topRight.y),
                bottomLeft = createHandle(bottomLeft.x, bottomLeft.y),
                bottomRight = createHandle(bottomRight.x, bottomRight.y)
            }

            -- Set rotation for rotation handles
            for _, handle in pairs(rotateHandles) do
                handle.rotation = selectedImage.rotation
                handle:addEventListener("touch", handleTouch)
            end
        end
    end
end

-- Touch listener for selecting an image
local function imageTouch(event)
    local image = event.target
    if event.phase == "began" then
        display.getCurrentStage():setFocus(image, event.id)
        image.isFocus = true
        image.startX, image.startY = event.x, event.y
        image.prevX, image.prevY = image.x, image.y
        if selectedImage ~= image then
            removeHandles()
            selectedImage = image
            showHandles()
            updateTextColors() -- Update text colors
        end
        if image == selectedImage then
            updateHandles()
        end
    elseif image.isFocus then
        if event.phase == "moved" then
            local dx, dy = event.x - image.startX, event.y - image.startY
            image.x, image.y = image.prevX + dx, image.prevY + dy
            if image == selectedImage then
                updateHandles()
            end
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.getCurrentStage():setFocus(image, nil)
            image.isFocus = false
        end
    end

    -- Select the clicked image
    if event.phase == "ended" then
        if selectedImage ~= image then
            removeHandles()
            selectedImage = image
            showHandles()
            updateTextColors() -- Update text colors
        end
    end
    return true
end

-- Create a ScrollView for the list of images
local scrollViewHeight = _H-83
local widget = require("widget")
local scrollView =
    widget.newScrollView(
    {
        width = 300, 
        height = scrollViewHeight,
        scrollWidth = 300, 
        scrollHeight = scrollViewHeight,
        verticalScrollDisabled = false,
        horizontalScrollDisabled = true,
        backgroundColor = {0.9, 0.9, 0.9}
    }
)
scrollView.x = _W - 150 -- Adjusted the x position to center the scroll view
scrollView.y = _H / 2
uiGroup:insert(scrollView)

local function showRenamePopup(imageID, textElement)
    local image = nil
    for i, img in ipairs(images) do
        if img.ID == imageID then
            image = img
            break
        end
    end

    if not image then
        return
    end -- Prevent the function from continuing if the image is nil

    local renameGroup = display.newGroup()
    local background = display.newRect(renameGroup, _W / 2, _H / 2, 300, 200)
    background:setFillColor(0.8, 0.8, 0.8, 0.8)

    local renameText =
        display.newText(
        {
            parent = renameGroup,
            text = "Rename Image",
            x = _W / 2,
            y = _H / 2 - 60,
            font = native.systemFont,
            fontSize = 24 * 2
        }
    )
    renameText:setFillColor(0)
    renameText.xScale = 0.5
    renameText.yScale = 0.5

    local nameInput = native.newTextField(_W / 2, _H / 2, 200, 40)
    renameGroup:insert(nameInput)

    local function onRenameComplete(event)
        if event.phase == "ended" then
            image.name = nameInput.text
            textElement.text = nameInput.text
            nameInput:removeSelf()
            renameGroup:removeSelf()
        end
        return true
    end

    local renameButton =
        display.newText(
        {
            parent = renameGroup,
            text = "OK",
            x = _W / 2,
            y = _H / 2 + 60,
            font = native.systemFont,
            fontSize = 20 * 2
        }
    )
    renameButton.xScale = 0.5
    renameButton.yScale = 0.5
    renameButton:setFillColor(0, 0, 1)
    renameButton:addEventListener("touch", onRenameComplete)
    uiGroup:insert(renameGroup)
end
local textElements = {} -- Table to store text elements

updateTextColors = function()
    for _, element in pairs(textElements) do
        if selectedImage and element.id == selectedImage.ID then
            element.text:setFillColor(0, 0, 1) -- Blue color for selected image
        else
            element.text:setFillColor(0) -- Black color for unselected images
        end
    end
end
-- Table to track the order of images
local imageOrder = {}

-- Function to initialize the image order table
local function initializeImageOrder()
    imageOrder = {}
    for i, img in ipairs(images) do
        table.insert(imageOrder, img.ID)
    end
end

-- Function to reorder the imageGroup based on the order table
local function reorderImageGroup()
    for i, imageID in ipairs(imageOrder) do
        for j, img in ipairs(images) do
            if img.ID == imageID then
                imageGroup:insert(img)
                break
            end
        end
    end
end

-- Function to move an image up in the order table
local function moveImageInOrderTableUp(imageID)
    for i = 2, #imageOrder do
        if imageOrder[i] == imageID then
            -- Swap the order in the table
            imageOrder[i], imageOrder[i - 1] = imageOrder[i - 1], imageOrder[i]
            break
        end
    end
end

-- Function to move an image down in the order table
local function moveImageInOrderTableDown(imageID)
    for i = 1, #imageOrder - 1 do
        if imageOrder[i] == imageID then
            -- Swap the order in the table
            imageOrder[i], imageOrder[i + 1] = imageOrder[i + 1], imageOrder[i]
            break
        end
    end
end

-- Initialize the image order table when adding a new image
local function addImageToList(imageID)
    local group = display.newGroup()
    group.id = imageID

    -- Find the image by ID
    local image
    for i, img in ipairs(images) do
        if img.ID == imageID then
            image = img
            break
        end
    end

    if not image then
        return
    end -- Exit if image not found
    local initialY = 30
    -- Text element for the image name
    local text =
        display.newText(
        {
            text = image.name, -- Use the image's name for display
            x = 20,
            y = initialY,
            font = native.systemFont,
            fontSize = 20 * 2
        }
    )
    text:setFillColor(0)
    text.xScale = 0.5
    text.yScale = 0.5
    text.anchorX = 0
    group:insert(text)

    -- Store reference to the text element and its group
    textElements[imageID] = {id = imageID, text = text, group = group} -- Ensure id is set

    -- Rename button
    local renameButton = display.newImage("GFX/edit.png")
    renameButton.x = 200
    renameButton.y = initialY
    renameButton.xScale = 0.3
    renameButton.yScale = 0.3
    renameButton:setFillColor(0.5, 0.5, 0.6)
    group:insert(renameButton)

    -- Touch listener for the rename button
    renameButton:addEventListener(
        "touch",
        function(event)
            if event.phase == "ended" then
                showRenamePopup(imageID, text)
            end
            return true
        end
    )

    -- Delete button
    local deleteButton = display.newImage("GFX/delete.png")
    deleteButton.x = 240
    deleteButton.y = initialY
    deleteButton.xScale = 0.3
    deleteButton.yScale = 0.3
    deleteButton:setFillColor(1, 0, 0)
    group:insert(deleteButton)

    -- Touch listener for the delete button
    deleteButton:addEventListener(
        "touch",
        function(event)
            if event.phase == "ended" then
                deleteImage(imageID)
            end
            return true
        end
    )

    -- Make the text element touch-sensitive to select the image
    text:addEventListener(
        "touch",
        function(event)
            if event.phase == "ended" then
                selectedImage = nil
                for i, img in ipairs(images) do
                    if img.ID == imageID then
                        selectedImage = img
                        break
                    end
                end
                removeHandles()
                showHandles()
                updateHandles()
                updateTextColors()
            end
            return true
        end
    )

    -- Adjust positions of existing elements to move them down
    for _, element in pairs(textElements) do
        if element.group ~= group then
            element.group.y = element.group.y + 40
        end
    end

    group.y = 0 -- Place the new element at the top
    scrollView:insert(group)

    -- Add the new image to the order table
    table.insert(imageOrder, imageID)
end
-- Function to update the Y positions of list items based on their order in the images table
local function updateImageListOrder()
    for i = 1, #images do
        local image = images[i]
        if textElements[image.ID] then
            -- Position elements so that the newest is at the top
            textElements[image.ID].group.y = (#images - i) * 40
        end
    end
end
-- Function to delete an image and update the scroll view
deleteImage = function(imageID)
    -- Remove the image from the images table
    for i, img in ipairs(images) do
        if img.ID == imageID then
            if selectedImage == img then
                removeHandles()
            end
            -- Remove the image from the display group
            img:removeSelf()
            table.remove(images, i)
            break
        end
    end

    -- Remove the image from the order table
    for i, id in ipairs(imageOrder) do
        if id == imageID then
            table.remove(imageOrder, i)
            break
        end
    end

    -- Remove the corresponding text element
    if textElements[imageID] then
        textElements[imageID].group:removeSelf()
        textElements[imageID] = nil
    end

    -- Update the scroll view positions
    updateImageListOrder()
    reorderImageGroup()
end


-- Function to move an image to the top in the order table
local function moveImageInOrderTableToTop(imageID)
    for i = 1, #imageOrder do
        if imageOrder[i] == imageID then
            table.remove(imageOrder, i)
            table.insert(imageOrder, 1, imageID)
            break
        end
    end
end

-- Function to move an image to the bottom in the order table
local function moveImageInOrderTableToBottom(imageID)
    for i = 1, #imageOrder do
        if imageOrder[i] == imageID then
            table.remove(imageOrder, i)
            table.insert(imageOrder, imageID)
            break
        end
    end
end

-- Function to move an image to the top
moveImageToBottom = function(imageID)
    moveImageInOrderTableToTop(imageID)
    reorderImageGroup()
    updateImageListOrder()
end

-- Function to move an image to the bottom
moveImageToTop = function(imageID)
    moveImageInOrderTableToBottom(imageID)
    reorderImageGroup()
    updateImageListOrder()
end

-- Function to move an image up
moveImageUp = function(imageID)
    moveImageInOrderTableUp(imageID)
    reorderImageGroup()
    -- Swap the Y positions in the scroll view list
    for i = 1, #images do
        if images[i].ID == imageID then
            if i > 1 then
                local tempY = textElements[images[i].ID].group.y
                textElements[images[i].ID].group.y = textElements[images[i - 1].ID].group.y
                textElements[images[i - 1].ID].group.y = tempY
            end
            break
        end
    end
    updateImageListOrder()
end

-- Function to move an image down
moveImageDown = function(imageID)
    moveImageInOrderTableDown(imageID)
    reorderImageGroup()
    -- Swap the Y positions in the scroll view list
    for i = 1, #images do
        if images[i].ID == imageID then
            if i < #images then
                local tempY = textElements[images[i].ID].group.y
                textElements[images[i].ID].group.y = textElements[images[i + 1].ID].group.y
                textElements[images[i + 1].ID].group.y = tempY
            end
            break
        end
    end
    updateImageListOrder()
end

-- Initialize the image order table when adding a new image
local function nextStep(FileToProcessPath)
    local uniqueID = os.time() -- Use a timestamp or a UUID for a unique ID
    createdImmages = createdImmages + 1
    local newImage = display.newImage(Service.get_file_name(FileToProcessPath), system.TemporaryDirectory)
    newImage.path = FileToProcessPath
    newImage.x = _W / 2
    newImage.y = _H / 2
    newImage.ID = uniqueID -- Unique internal ID
    newImage.name = "Image" .. (createdImmages) -- Name for display purposes
    --newImage.path = Service.get_file_name(FileToProcessPath) -- Store the image path
    newImage:addEventListener("touch", imageTouch)
    imageGroup:insert(newImage) -- Add the new image to the imageGroup
    table.insert(images, newImage)

    -- Add the new image to the list
    addImageToList(newImage.ID)

    -- Select the new image and update text colors
    if selectedImage then
        removeHandles()
    end
    selectedImage = newImage
    showHandles()
    updateTextColors() -- Update text colors
    -- Initialize the image order table
    initializeImageOrder()
end
-- Function to load the file using tinyfiledialogs plugin
local function LoadFileFN()
    local opts = {
        title = "Choose image (PNG) to process",
        filter_patterns = "*.png",
        filter_description = "PNG FILES",
        allow_multiple_selects = false
    }
    local FileToProcessPath = myPlugin.openFileDialog(opts)
    if FileToProcessPath then
        Service.copyFileToSB(
            Service.get_file_name(FileToProcessPath),
            Service.getPath(FileToProcessPath),
            Service.get_file_name(FileToProcessPath),
            system.TemporaryDirectory,
            true
        )
        nextStep(FileToProcessPath)
    end
end
ButtonAddNew.currentXScale = ButtonAddNew.xScale
ButtonAddNew.currentYScale = ButtonAddNew.yScale

-- Event listener function for the load file button
local function LoadFileFunction(event)
    local self = event.target
    if event.phase == "began" then
        display.getCurrentStage():setFocus(self, event.id)
        self.xScale = self.currentXScale - 0.05
        self.yScale = self.currentYScale - 0.05
        self.isFocus = true
    elseif self.isFocus then
        if event.phase == "ended" or event.phase == "cancelled" then
            self.xScale = self.currentXScale
            self.yScale = self.currentYScale
            display.getCurrentStage():setFocus(self, nil)
            self.isFocus = false
            LoadFileFN()
        end
    end
    return true
end

ButtonAddNew:addEventListener("touch", LoadFileFunction)

-- Touch listener for deselecting the image by clicking on the background
local function backgroundTouch(event)
    if event.phase == "ended" then
        if selectedImage then
            removeHandles()
            selectedImage = nil
            updateTextColors() -- Update text colors
        end
    end
    return true
end





--- -save load functionality
local function gatherImageData()
    local imageData = {}
    for i, img in ipairs(images) do
        table.insert(imageData, {
            path = img.path,
            name = img.name,
            x = img.x,
            y = img.y,
            width = img.width,
            height = img.height,
            rotation = img.rotation,
            hierarchyIndex = i  -- Save the position in the display hierarchy
        })
    end
    return imageData
end

saveWorkspace = function()
    local opts = {
        title = "Save Workspace",
        filter_patterns = "*.lua",
        filter_description = "Lua Files",
        allow_multiple_selects = false,
    }
    local savePath = myPlugin.saveFileDialog(opts)
    if savePath then
        local imageData = gatherImageData()
        local serializedData = json.encode(imageData)
        local file = io.open(savePath, "w")
        if file then
            file:write(serializedData)
            file:close()
        else
            print("Error saving file")
        end
    end
end

local function clearWorkspace()
    for _, img in ipairs(images) do
        img:removeSelf()
    end
    images = {}
    imageOrder = {}
    textElements = {}
    removeHandles()

    -- Clear the scroll view contents
    if scrollView then
        scrollView:removeSelf()
        scrollView = nil

        -- Recreate the scroll view
        scrollView =
            widget.newScrollView(
            {
                width = 300, 
                height = scrollViewHeight,
                scrollWidth = 300, 
                scrollHeight = scrollViewHeight,
                verticalScrollDisabled = false,
                horizontalScrollDisabled = true,
                backgroundColor = {0.9, 0.9, 0.9}
            }
        )
        scrollView.x = _W - 150 -- Adjusted the x position to center the scroll view
        scrollView.y = _H / 2
        uiGroup:insert(scrollView)
    end
end

loadWorkspace = function()
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

            -- Add check for hierarchyIndex presence
            for _, data in ipairs(imageData) do
                if not data.hierarchyIndex then
                    print("Error: Missing hierarchyIndex in saved data")
                    return
                end
            end

            -- Prompt for confirmation to clear current workspace
            local confirm = native.showAlert("Confirmation", "Do you want to clear the current workspace?", { "Yes", "No" }, function(event)
                if event.action == "clicked" and event.index == 1 then
                    clearWorkspace()

                    -- Load new images
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
                        newImage.ID = os.time() + math.random(1, 1000)  -- Generate a unique ID
                        newImage.name = data.name
                        newImage.path = originalPath
                        newImage.hierarchyIndex = data.hierarchyIndex  -- Ensure hierarchyIndex is preserved
                        newImage:addEventListener("touch", imageTouch)
                        table.insert(images, newImage)
                        addImageToList(newImage.ID)
                    end

                    -- Sort images based on hierarchyIndex and populate imageOrder
                    table.sort(images, function(a, b)
                        return a.hierarchyIndex > b.hierarchyIndex
                    end)
                    for _, img in ipairs(images) do
                        table.insert(imageOrder, img.ID)
                    end

                    -- Reorder the imageGroup to reflect the hierarchy
                    reorderImageGroup()

                    initializeImageOrder()
                end
            end)
        else
            print("Error loading file")
        end
    end
end



-- Add the background touch listener to the entire screen
local background = display.newRect(_W / 2, _H / 2, _W, _H)
background:setFillColor(1, 1, 1, 0.7) -- Set to nearly transparent
background:addEventListener("touch", backgroundTouch)
background:toBack() -- Send background to the back layer
