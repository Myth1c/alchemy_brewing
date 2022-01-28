Brew_Config = {

    -- Enable DEBUGING mode. This will cause messages to print to console at various points in the code.
    BREWING_DEBUG = { Enabled = 1},

    --[[
        General UI Settings
        The settings here apply to every VGUI element that gets displayed.
    ]]--

    -- Set font type used for title of VGUI Elements
    -- Default: DermaLarge
    GUI_Font = "DermaLarge",
    -- Set the main color of title text
    -- Default: Color(255, 255, 255, 255)
    GUI_Font_mainColour = Color(255, 255, 255, 255),
    -- Set the backdrop color for font
    -- Default: Color(119, 135, 135, 255)
    GUI_Font_shadowColour = Color(119, 135, 137, 255),
    -- Set how much panels should round out around the corners. 0 = off
    -- Default: 10
    GUI_FrameCurve = 10,

    --[[
        Brewing UI Section
        The options under here are explicitly for the Brewing UI
    ]]--
    -- Set the amount of ingredients that can be added to a potion. Max = 5
    -- Default: 3
    Max_Ingredients = 3,
    -- Set the color for the foreground of the main frame
    -- Default: Color(120, 120, 120, 255)
    GUI_Brew_Foreground = Color(120, 120, 120, 255),
    -- Set the color for the background of the main frame
    -- Default: Color(0, 0, 0, 255)
    GUI_Brew_Background = Color(0, 0, 0, 255),
    -- Set the color for the background of the input/output slots
    -- Default: Color(60, 60, 60, 255)
    GUI_BrewSlot_Background = Color(60, 60, 60, 255),
    -- Set what image appears inside the brewing slots. Don't recommend changing but you do you.
    -- Default: "decals/light"
    GUI_BrewSlot_Image = "decals/light",

    --[[
        Table Inventory UI Section
        The options here only apply to the inventory UI that is accessed upon interacting with a table
    ]]--
    -- Set how many inventory slots should appear in the inventory UI. Not recommended to go above 75 as the UI will fall off the screen.
    -- Default: 25
    Inventory_Size = 25,
    -- Set how large the inventory boxes will apear
    -- Default: 50
    Inventory_BoxSize = 50,
    -- Set how much space is between each inventory box in the UI
    -- Default: 5
    Inventory_Padding = 5,
    -- Set the foreground color of the main frame for the inventory UI
    -- Default: Color(50, 50, 50, 255)
    GUI_Inventory_Foreground = Color(50, 50, 50, 255),
    -- Set the background color of the main frame for the inventory UI
    -- Default: Color(0, 0, 0, 255)
    GUI_Inventory_Background = Color(0, 0, 0, 255),
    -- Set the header color of the main frame for the inventory UI
    -- Default: Color(150, 150, 150, 255)
    GUI_Inventory_Header = Color(150, 150, 150, 255)



}