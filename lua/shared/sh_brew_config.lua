Brew_Config = {

    -- Enable DEBUGING mode. This will cause messages to print to console at various points in the code.
    BREWING_DEBUG = { Enabled = 1},

    --[[
        General Addon settings
    ]]--
    -- Changes the max effects a player can have at a given time.
    -- Default: 4
    Max_Effects = 4,
    -- Global max for potions. Potions can not have more than this many tiers of ANY type. IE Speed 3 + Leaping 2 = 5 so no more
    -- Default: 5
    Global_Max_Tier = 5,

    -- Change the max tiers for each individual effect. Potions set down here will never go beyond the given maxes.
    -- Speed potion's max tier.
    -- Default: 5
    Speed_Max_Tier = 5,
    -- Leaping potion's max tier.
    -- Default: 5
    Leaping_Max_Tier = 5,
    -- Healing potion's max tier.
    -- Default: 4
    Health_Max_Tier = 4,
    -- Shield potion's max tier.
    -- Default: 4
    Shield_Max_tier = 4,
    -- Should ingredients be dropped on death?
    -- Default: false
    Drop_Inventory_On_Death = false,
    -- How long should a potion take to brew (in seconds)
    -- Default: 15
    Brew_Brew_Time = 15,
    -- Should tiers affect brew time? Time is multiplied by total tiers in potion. IE tier 1 = 15 seconds, tier 4 = 60 seconds
    -- Default: true
    Brew_Tiers_Are_Multipliers = true,

    --[[
        General UI Settings
        The settings here apply to every VGUI element that gets displayed.
    ]]--

    -- Set font type used for title of VGUI Elements
    -- Default: Brew_UIFont
    GUI_Font = "Brew_UIFont",
    -- Set the main color of title text
    -- Default: Color(255, 255, 255, 255)
    GUI_Font_mainColour = Color(255, 255, 255, 255),
    -- Set the backdrop color for font
    -- Default: Color(119, 135, 135, 255)
    GUI_Font_shadowColour = Color(119, 135, 137, 255),
    -- Set how much panels should round out around the corners. 0 = off
    -- Default: 10
    GUI_FrameCurve = 10,
    -- The color for the border of a selected ingredient when inspecting an ingredient (Left click in the inventory)
    -- Default: Color(0, 161, 255, 255)
    GUI_BrewSlot_Hover = Color(0, 161, 255, 255),

    --[[
        Brewing UI Section
        The options under here are explicitly for the Brewing UI
    ]]--

    -- Set the amount of ingredients that can be added to a potion. Max = 5
    -- Default: 4
    Max_Ingredients = 4,
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
    GUI_Inventory_Header = Color(150, 150, 150, 255),


    --[[
        Context Menu Section
        The options here are for the context menu that shows when right-clicking an item in the brewing or inventory UIs
    ]]--

    -- Set the Button's Foreground Colors
    -- Default: Color(120,120,120, 0)
    GUI_Context_Button_Foreground = Color(120,120,120, 255),
    -- Set the Button's border color
    -- Default: Color(0, 0, 0, 0)
    GUI_Context_Button_Border = Color(0,0,0, 255),
    -- Set the Main Frame's border color
    -- Default: Color(0, 0, 0, 0)
    GUI_Context_Main_Border = Color(0,0,0, 255),

    --[[
        Status Indicator Settings
        The options below this are only for the status indicators that show when drinking potions
    ]]--

    -- Set the Status Indicator's Foreground Color
    -- Default: Color(120,120,120, 125)
    GUI_Status_Foreground = Color(120,120,120, 125),
    -- Set the Status Indicator's Border Color
    -- Default: Color(0,0,0, 125)
    GUI_Status_Border = Color(0,0,0, 125),
    -- Set the amount the indicator rounds
    -- Default: 2
    GUI_Status_Curve = 2,
    -- Set the font the status Indicator uses
    -- Default: "Brew_Status_Font"
    GUI_Status_Font = "Brew_StatusFont",

    --[[
        Speed Effect Settings
        The options below apply to the speed effect when given to a player
    ]]--
    -- Set this to your default run speed on your server. If you don't know how to find that out, open console type cl_showpos 1 then look at "vel: "
    -- copy the number next to that while holding the w key
    Effect_DefaultRunSpeed = 400,

    -- Speed potion time calculation is: base time + (time multiplier * tier)
    -- A tier 1 speed potion would be: 10 * (1 * 1) meaning you get a 10 second speed potion. Tier 2 would be 20 seconds.
    -- Changes the base time for a speed potion. 
    -- Default: 10
    Effect_Speed_TimeLimit_Base = 10,
    -- Changes the multiplier for the time of a speed potion.
    -- Default: 1
    Effect_Speed_TimeLimit_Multiplier = 1,

    -- Speed potion boost calculation is: base boost + (boost multiplier * tier). 
    -- A tier 1 speed potion would be: 1 + (0.25 * 1) meaning you get a 1.25x run boost, increasing from 400 units to 500. Tier 2 would be 600 units.
    -- Changes the base speed increase. 
    -- Default: 1
    Effect_Speed_SpeedBoost_Base = 1,
    -- Changes the multiplier for the boost of a speed potion.
    -- Default: 0.25
    Effect_Speed_SpeedBoost_Multiplier = 0.25,
    
    --[[
        Leaping Effect Settings
        The options below apply to the speed effect when given to a player
    ]]--
    -- Set this to your default jump power on your server.
    Effect_DefaultJumpPower = 280,

    -- Leaping potion time calculation is: base time + (time multiplier * tier)
    -- Changes the base time for a leaping potion. 
    -- Default: 10
    Effect_Leaping_TimeLimit_Base = 10,
    -- Changes the multiplier for the time of a leaping potion.
    -- Default: 1
    Effect_Leaping_TimeLimit_Multiplier = 1,

    -- Leaping potion boost calculation is: base boost + (boost multiplier * tier)
    -- Default: 1
    Effect_Leaping_JumpBoost_Base = 1,
    -- Changes the multiplier for the boost of a Leaping potion.
    -- Default: 0.25
    Effect_Leaping_JumpBoost_Multiplier = 0.25,

    --[[
        Healing Potion Settings
        These options are to customize how healing potions work
    ]]--
    -- The amount a standard potion will heal. It is multiplied by it's tier for amount to heal.
    -- Default: 25
    Effect_Healing_Amount = 25,

    --[[
        If Overheal decay is turned on, these settings will effect healing potions
    ]]--
    -- Set to false to turn overheal decay off.
    -- Default: true
    Effect_Overheal_Decay = true,
    -- Changes the max amount of hp you can get to while Overheal decay is turned on. The values are separate so you can set this higher if you wish.
    -- Default: 200
    Effect_Overheal_DecayMaxHP = 200,
    -- Changes how quickly overheal will decay. The target loses 1 hp every 3 seconds by default
    -- Default: 3
    Effect_Overheal_DecayRate = 3,
    -- Changes at what health value overheal decay will start at. Whenever a player is above this health value, they will return to it over time
    -- Default: 100
    Effect_Overheal_DecayStart = 100,

    --[[
        If Overheal decay is turned off, these settings will effect healing potions
    ]]--
    -- Changes the max HP a player can have. 
    -- Default: 125
    Effect_Healing_MaxHP = 125,

    --[[
        Shield Potion Settings
        These options customize the shield potions and how they effect their users.
    ]]--
    -- Changes how much shield a potion will give per tier. Tier 1 = 25, 2 = 50, 3 = 75, etc
    -- Default: 25
    Effect_Shield_Base = 25,
    -- Changes the max amount of shields a player is allowed to have
    -- Default: 100
    Effect_Shield_Max = 100,


}