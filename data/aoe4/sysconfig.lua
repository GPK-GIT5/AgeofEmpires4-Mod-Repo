version = 3666938 -- update SystemConfig.cpp when you update this, but we should avoid updating this now that the game
-- has gone live.  It will wipe player settings.
-- 3631008 Hide physics "off" option when "graphicsquality" setting is low
-- 3650261 Support pending setting a setting value.
-- 3666938 Split autodetect into CPU/RAM/GPU/VRAM. See user story 137384

-- For settings, use the variant type field
-- e.g.:
-- variantBool = true or variant = true
-- variant = 3.5 or variantFloat = 3.5
-- variantInt = -1 (do not use the implicit typing "variant", otherwise it will be parsed as variantFloat
-- variantUInt = 10 (do not use the implicit typing "variant", otherwise it will be parsed as variantFloat
-- variantString = "abc" or variantString = "abc"
-- variantKey = "hashkeystring"

-- Settings options:
-- valueStore -- default: valueStoreSystem
	-- settings that are valueStore = valueStoreUser are not available during start until cloud storage load completes
-- canOverrideDefault -- default: false
	-- e.g. high graphics: we override the default on slow PCs
-- canPreview -- default: false
-- uiType -- default: invalid
-- nameLocID
-- descLocID
-- dataTemplate
-- uiAvailability -- default: UA_Both
-- platformAvailability -- default: PA_All
	-- this applies to the *store*/API platform that the setting is available on, e.g. Steam or XboxLive
-- hardwareAvailability -- default: HA_All
	-- this applies to the *hardware* platform, e.g. Xbox console or PC
-- isDebug -- default: false
-- persistent -- default: true -- when true the setting will always use its saved value (including cloud saves), when false it will use its default value unless "showdebugsettings" is in use, in which case it will use the saved value
-- telemetryName -- max: 64 chars
-- xboxOverride -- default: false (if there is a setting with the same name it will be overriden by the one with xboxOverride true on Xbox)
-- canChangeInGame -- default: true (this applies to the setting which cannot be changed in-game like Input Device)

-- UT_Range settings:
-- rangeMin -- default: 0
-- rangeMax -- default: 1
-- tickFrequency -- default: 1.0

-- UT_List/list settings:
-- locNameID
-- descLocID
-- metaData/key

valueStoreSystem = 1
valueStoreUser = 2

--~ These are used to tweak the options screen
applicationBaseMemory = 500
d3d10AdditionalMemory = 32
allowableVirtualMemoryUsage = 128

-- Must match UIType in SystemConfig
-- boolean for checkbox, toggle and so on
UT_Bool = 0
-- float ranged values for slider, edit box and so on
UT_Range = 1
-- a list of int values and their display strings for dropdown, combobox and so on
UT_List = 2
-- user custom
UT_Custom = 3

-- Must match UIAvailability in SystemConfig
-- show both on Frontend and in game
UA_Both = 0
-- show only on Frontend
UA_FE = 1
-- show only in game
UA_InGame = 2

-- Platform Availability; must match PlatformAvailability in SystemConfig
-- show both on Steam and Xbox online platforms
PA_All = 0
-- show only on Steam
PA_Steam = 1
-- show only on Xbox (i.e. XboxLive, i.e Microsoft Store or Xbox)
PA_Xbox = 2
-- show only on PS5
PA_PS5 = 3

-- Hardware Availability bit-mask; must match UIHardwareAvailability in SystemConfig
-- visible only on Desktop (Steam, MS Store)
HA_PC = 1
-- visible only on Xbox
HA_Xbox = 2
-- visible only on PS5
HA_PS5 = 4
-- Consoles only (Xbox | PS5)
HA_Console = 6
-- Visible on all hardware platforms (PC | Xbox | PS5)
HA_All = 7

-- setting control data templates
DT_ToggleCheckBox = "ToggleCheckBox"
DT_ComboBox = "ComboBox"
-- Display rounded value
DT_HDR = "HDR"
DT_Slider = "Slider"
DT_Resolution = "Resolution"
DT_AudioInputDevice = "AudioInputDevice"
DT_AudioOutputDevice = "AudioOutputDevice"
DT_Button = "Xbox_Button"

--~ memoryUsed is a table corresponding to the additional memory used by the setting above the baseline
--~ If a value is not listed (e.g. nothing for medium or low, or if memoryUsed is absent ) then a
--~ default value of zero is used.

configuration =
{
	-- Enable tutorial prompts
	{	
		setting = "TutorialInterfaceEnabled",  variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11149474, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Tutorial Interface Enabled",
	},
	-- Game Window
	{   
		setting = "windowmode", variantUInt = 0, canOverrideDefault = true, valueStore = valueStoreSystem,
		nameLocID = 11166270, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Game Window",
		list = 
		{ 
			-- Borderless Fullscreen 
			{variantUInt = 0, locNameID = 11166271}, 
			-- Exclusive Fullscreen
			{variantUInt = 1, locNameID = 11166272},
			-- Full Desktop
			{variantUInt = 3, locNameID = 11196173},
			-- Windowed
			{variantUInt = 2, locNameID = 11166273},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183101"},
		},
	},
	-- Resolution.
	-- Leave as empty string "" to let autodetect determine resolution and refresh rate. Autodetect will set the default
	-- to match the user's screen resolution. For devices with low hardware specs and high native resolution (i.e.
	-- laptops or tablet PC's), resolution downscaling will be handled by the "GameplayScale" and
	-- "Autoconfig_GameplayScaleTargetResolution" settings.
	-- Default is set by graphics autodetect as the resolution of the primary monitor, or is the maximum allowable for a specific gen (i.e. don't allow Gen 7 devices to boot in 4k)
	{
		setting = "resolution", variantString = "", canOverrideDefault = true, valueStore = valueStoreSystem,
		nameLocID = 22016, dataTemplate = DT_Resolution, uiType = UT_Custom, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Resolution",
		metaData = 
		{
			{key = "FullscreenBorderlessTooltip", variantInt = 11189193},
		},
	},
	-- GameplayScale
	-- If the default for "Autoconfig_GameplayScaleTargetResolution" is set, then the default value for "GameplayScale"
	-- will be overridden with a gameplay scale factor that achieves the target resolution.
	{	
		setting = "gameplayscale", variantFloat = 1.0, canOverrideDefault = true, canPreview = false,
		nameLocID = 11205945, uiType = UT_Range, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		rangeMin = 0.25, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "GameplayScale",  uiModelTypeOverride="GameplayScaleSettingModel",
		dataTemplate = "GameScaleSlider",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"},
			{key = "TooltipLocKey", variantString = "$11205947"},
		}
	},
	-- Used by autoconfig to set default gameplay scale. If this default not an empty string, then autodetect will
	-- override the default for "GameplayScale" with a gameplay scale factor that achieves this target resolution. The
	-- "autoconfig_gen*" settings groups below may set this string.
	{
		setting = "Autoconfig_GameplayScaleTargetResolution", variantString = "", canOverrideDefault = true, valueStore = valueStoreSystem,
		nameLocID = 400, dataTemplate = DT_Resolution, uiType = UT_Custom,
		telemetryName = "Autoconfig Gameplay Scale Target Resolution",
		metaData = 
		{
			{key = "FullscreenBorderlessTooltip", variantInt = 11189193},
		},
	},
	-- Graphics Quality
	{
		setting = "graphicsquality", variantUInt = 0, canOverrideDefault = true, valueStore = valueStoreSystem,
		nameLocID = 11204193, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Image Quality", canPreview = true,
		list = 
		{ 
			-- Low
			{variantUInt = 0, locNameID = 2905 },
			-- Medium
			{variantUInt = 1, locNameID = 2904 },
			-- High
			{variantUInt = 2, locNameID = 2903 },
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11205379"},
		},
	},
	-- Used by autodetect to determine whether
	{
		setting = "autodetect_previousgraphicsquality", variantUInt = 9999, canOverrideDefault = true, valueStore = valueStoreSystem,
		nameLocID = 400, 	dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "autodetect_previousgraphicsquality",
	},
	-- Animation Quality
	-- 0 = Low, 1 = Medium, 2 = High, 3 = Very Low
	{
		setting = "animationquality", variantUInt = 0, canOverrideDefault = true, valueStore = valueStoreSystem,
		nameLocID = 11205001, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "animationquality Quality",
		list = 
		{
			-- Very Low
			{variantUInt = 3, locNameID = 2946},
			-- Low
			{variantUInt = 0, locNameID = 2905},
			-- Medium
			{variantUInt = 1, locNameID = 2904},
			-- High
			{variantUInt = 2, locNameID = 2903},
		},
	},
	-- Shadow Quality Settings
	-- Rendering maps this setting to shadow quality. See shadowQualitySettings in GraphicsConfig.cpp for details.
	-- This should be named "Shadows", but we shouldn't be changing the names of these settings after launch without
	-- a plan to migrate users to the new setting name without messing up their settings.
	{
		setting = "VolumetricLighting", variantUInt = 1, valueStore = valueStoreSystem,
		nameLocID = 11216441, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Lighting Quality", canOverrideDefault = true,
		list = 
		{
			-- Off -- This was added post-launch, so we shouldn't change the values for low medium and high
			{variantUInt = 3, locNameID = 2901},
			-- Low
			{variantUInt = 0, locNameID = 2905},
			-- Medium
			{variantUInt = 1, locNameID = 2904},
			-- High
			{variantUInt = 2, locNameID = 2903},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11216458"},
		},
	},
	-- Ambient Occclusion	
	{
		setting = "AmbientOcclusion", variantUInt = 1, valueStore = valueStoreSystem,
		nameLocID = 11248179, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Ambient Occlusion", canOverrideDefault = true,
		list = 
		{
			-- Off
			{variantUInt = 0, locNameID = 2901},
			-- Low
			{variantUInt = 1, locNameID = 2905},
			-- Medium
			{variantUInt = 2, locNameID = 2904},
			-- High
			{variantUInt = 3, locNameID = 2903},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11248216"},
		},
	},
	-- Anti-aliasing (0=off, 0.5=low, 1=high)
	{
		setting = "AntiAliasing", variantFloat = 0, canOverrideDefault = true, valueStore = valueStoreSystem,
		nameLocID = 701007, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Anti-Aliasing",
		list = 
		{ 			
			-- Off
			{variantFloat = 0, locNameID = 2901}, 
			-- Low
			{variantFloat = 0.5, locNameID = 2905}, 
			-- High,
			{variantFloat = 1.0, locNameID = 2903},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183059"},
		},
	},
	-- Framerate Limit
	{
		setting = "FrameRateLimit", variantUInt = 0, canOverrideDefault = true,
		nameLocID = 11197967, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Framerate Limit", uiModelTypeOverride = "FrameRateLimitSettingModel",
		list =
		{
			-- Unlimited
			{variantUInt = 0, locNameID = 11197968},
			-- 30 FPS
			{variantUInt = 30, locNameID = 11197969},
			-- 60 FPS
			{variantUInt = 60, locNameID = 11197970},
			-- 75 FPS
			{variantUInt = 75, locNameID = 11198572},
			-- 120 FPS
			{variantUInt = 120, locNameID = 11198573},
			-- 144 FPS
			{variantUInt = 144, locNameID = 11198574},
			-- 165 FPS
			{variantUInt = 165, locNameID = 11198575},
		}
	},
	-- V-sync (0=off, 1=on)
	{
		setting = "VerticalSync", variantBool = true, canOverrideDefault = true,
		nameLocID = 11149481, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Vertical Sync",
	},
	-- Number of mip levels to drop [0,3]
	-- Note that Medium is grayed out if the user has less than 4GB of VRAM, and High is grayed out if the user has less than 6GB of VRAM. See attributes/tuning_presentation/settings/setting_option_requirements in the Attribute Editor.
	{	
		setting = "TextureDetail", variantUInt = 0, canOverrideDefault = true,
		nameLocID = 11149479, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Texture Detail",
		list =
		{
			-- Low
			{variantUInt = 2, locNameID = 2905},
			-- Medium
			{variantUInt = 1, locNameID = 2904},
			-- High
			{variantUInt = 0, locNameID = 2903},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183061"},
		},
	},
	-- HDR
	{	
		setting = "HDR", variantBool = false, canOverrideDefault = true, valueStore = valueStoreSystem,
		nameLocID = 11167056, dataTemplate = DT_HDR, uiType = UT_Bool, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "HDR", uiModelTypeOverride = "HDRSystemConfigSettingModel",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183049"},
		},
	},
	-- Resolution selector for movie player
	{	
		setting = "MoviePlayerPixelCount", variantInt = 8294400, canOverrideDefault = true, valueStore = valueStoreSystem,
		canPreview = false, nameLocID = 11196220, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Movie Quality",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11197524"},
		},
		list =
		{
			-- "Match screen resolution"
			-- {variantInt = -1, locNameID = 11197982}, -- not needed for Cardinal: we only have 1080p and 4K
			-- "1080p" 1920 x 1080 = 2073600 
			{variantInt = 2073600, locNameID = 11197522},
			-- "4K HDR (If Downloaded and System Capable)" 3840 x 2160 = 8294400
			{variantInt = 8294400, locNameID = 11197523}, -- this is the setting default - 4K movie is auto selected if downloaded and resolution and system supports it when set to this
		},
	},
	-- Enable shadows (4=pcss ( 24 point shadows), 3=high (16 point shadows), 2=medium (8 point shadows), 
	-- 1=low (4 point shadows), 0=off)
	-- Autodetect should set this through GraphicsQuality.
	{
		setting = "Shadows", variantUInt = 4,
		nameLocID = 11167052, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Shadow Distance",
		list =
		{
			-- Off
			{variantUInt = 0, locNameID = 2901},
			-- Low
			{variantUInt = 1, locNameID = 2905},
			-- Medium
			{variantUInt = 2, locNameID = 2904},
			-- High
			{variantUInt = 3, locNameID = 2903},
			-- Ultra
			{variantUInt = 4, locNameID = 2902},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183062"},
		},
		isDebug = true,
	},
	-- Physics (0 - off, 1~3 on, 3 is only selectable internally)
	{
		setting = "Physics", variantUInt = 0, canOverrideDefault = true, valueStore = valueStoreSystem,
		nameLocID = 701008, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Physics", pendingBehavior="appinit",
		list =
		{
			-- Off
			{variantUInt = 0, locNameID = 2901},
			-- Low
			{variantUInt = 1, locNameID = 2905},
			-- High
			{variantUInt = 2, locNameID = 2903},
		}
	},
	-- Sticky selection
	{	
		setting = "StickySelection", variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11149472, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Sticky Selection",
		metaData=
		{
			{key = "TooltipLocKey", variantString = "$11182907"},
		},
	},
	
	-- Camera rotation
	{	
		setting = "CameraRotation", isDebug = true, variantBool = true,	valueStore = valueStoreUser,
		nameLocID = 11166674, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Camera Rotation",
	},
	-- Balance (0..100)
	{
		setting = "audioBalance", variantFloat = 50.0,	
		nameLocID = 11167084, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0, rangeMax = 100.0, tickFrequency = 1.0,
		isDebug = true, telemetryName = "Balance",
	},
	-- Master volume (0..100)
	{	
		setting = "masterVolume", variantFloat = 1.0, canPreview = true, 
		nameLocID = 701002, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Master Volume",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"}
		}
	},
	
	-- Music volume (0..100)
	{	
		setting = "musicVolume", variantFloat = 1.0, canPreview = true,
		nameLocID = 701004, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Music Volume",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"}
		}
	},
	-- SFX volume (0..100)
	{	
		setting = "sfxVolume", variantFloat = 1.0, canPreview = true,
		nameLocID = 11149485, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Sound Effects Volume",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"}
		}
	},
	-- Speech volume (0..100)
	{
		setting = "speechVolume", variantFloat = 1.0, canPreview = true,
		nameLocID = 701003, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Speech Volume",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"}
		}
	},
	-- Taunts volume (0..100)
	{
		setting = "tauntsVolume", variantFloat = 1.0, canPreview = true,
		nameLocID = 11231315, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Speech Volume",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"}
		}
	},
	-- (Audio) Output Quality (High, Medium (default), Low) <- PC Only
	-- Note that Medium and High are grayed out if the user has less than 8GB of RAM to pregent OOM crashes. See attributes/tuning_presentation/settings/setting_option_requirements in the Attribute Editor.
	{
		setting = "AudioOutputQuality", variantUInt = 0, canOverrideDefault = true,
		nameLocID = 11168792, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Audio Output Quality",
		list =
		{
			-- High
			{variantUInt = 0, locNameID = 11167086},
			-- Medium
			{variantUInt = 1, locNameID = 2922},
			-- Low
			{variantUInt = 2, locNameID = 2923},
			-- Console Settings
			-- 		As we do not want the following settings to be expressed in the options UI we will only list them as comments in this area
			-- Xbox One X = 3
			-- Xbox One and Xbox One S == 4
			-- Series X = 5
			-- Series S = 6
			-- Playstation5 = 7
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$701080"},
		},
	},
	-- (Audio) Dynamic range (Wide (Default), Boost, Midnight Mode)
	{
		setting = "AudioDynamicRange", variantUInt = 0, canOverrideDefault = true,
		nameLocID = 11167092, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Audio Dynamic Range",
		list =
		{
			-- Wide Mode
			{variantUInt = 0, locNameID = 11167091},
			-- Boost
			{variantUInt = 1, locNameID = 11167090},
			-- Midnight Mode
			{variantUInt = 2, locNameID = 11167089},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183051"},
		},
	},
	-- Swap Shift and Alt Modifier Keys
	{
		setting = "SwapShiftAndAltKeys", variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11165901, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Swap Shift and Alt Modifier Keys",
	},
	-- Exclusive Control Groups
	{
		setting = "ExclusiveControlGroups", variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11219581, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Exclusive Control Groups",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11219582"},
		},
	},
	
	-- Idle Villager ("worker") Follow/Snap/Select: 0 = Follow, 1 = Select and Center Camera (Default), 2 = Select Only
	{
		deprecated_value = 1, 			valueType = deprecated_valueTypeUInt,
		setting = "IdleVillagerPickType", variantInt = 1,		valueStore = valueStoreUser,
		nameLocID = 11164952, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Idle Villager",
		list =
		{
			-- 0 = Follow
			{variantInt = 0, locNameID = 11166488},
			-- 1 = Select and Center Camera (Default)
			{variantInt = 1, locNameID = 11166489},
			-- 2 = Select Only
			{variantInt = 2, locNameID = 11166490},
		}
	},
	-- Idle Military Follow/Snap/Select: 0 = Follow, 1 = Select and Center Camera (Default), 2 = Select Only
	{	
		setting = "IdleMilitaryPickType", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 11164953, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Idle Military",
		list =
		{
			-- 0 = Follow
			{variantInt = 0, locNameID = 11166488},
			-- 1 = Select and Center Camera (Default)
			{variantInt = 1, locNameID = 11166489},
			-- 2 = Select Only
			{variantInt = 2, locNameID = 11166490},
		}
	},	
	-- Find and Cycle Units & Buildings Follow/Snap/Select: 0 = Follow, 1 = Select and Center Camera (Default), 2 = Select Only
	{	
		setting = "FindAndCyclePickType", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 11164954, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Find and Cycle Units & Buildings",
		list =
		{
			-- 0 = Follow
			{variantInt = 0, locNameID = 11166488},
			-- 1 = Select and Center Camera (Default)
			{variantInt = 1, locNameID = 11166489},
			-- 2 = Select Only
			{variantInt = 2, locNameID = 11166490},
		}
		
	},
	-- Cycle through (subselect) selected units Follow/Snap/Select: 0 = Follow, 1 = Select and Center Camera (Default), 2 = Select Only
	{
		setting = "CycleSubselectionPickType", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 11164955, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Cycle through (subselect) selected units",
		list =
		{
			-- 0 = Follow
			{variantInt = 0, locNameID = 11166488},
			-- 1 = Select and Center Camera (Default)
			{variantInt = 1, locNameID = 11166489},
			-- 2 = Select Only
			{variantInt = 2, locNameID = 11166490},
		}
	},
	
	-- Focus on selected unit(s)
	{
		setting = "FocusSelectedFollow", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 11144991, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Focus on selected unit(s)",
		list =
		{
			-- 0 = Follow
			{variantInt = 0, locNameID = 11166488},
			-- 1 = Center Camera (Default)
			{variantInt = 1, locNameID = 11171399},
		}
	},

	-- Command Queue Mode
	{
		setting = "CommandQueueMode", variantInt = 0, valueStore = valueStoreUser,
		nameLocID = 11232741, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Command Queue Mode",
		list =
		{
			-- 0 = End On Release (Default)
			{variantInt = 0, locNameID = 11232742},
			-- 1 = Classic
			{variantInt = 1, locNameID = 11232743},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11232744"},
		},
	},
	
	-- Default camera mode denoted by zoom level, i.e. distance and pitch
	{	
		setting = "CameraMode", variantInt = 0, valueStore = valueStoreUser, 
		nameLocID = 11225907, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Camera mode",
		list =
		{
			-- 0 = Classic 
			{variantInt = 0, locNameID = 11225909},
			-- 1 = Panoramic 
			{variantInt = 1, locNameID = 11225908},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11226539"},
		},
	},

	-- Scroll wheel zooms camera
	{
		setting = "ScrollWheelZoom", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11149473, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Mouse wheel zoom",
	},
	
	-- Scroll wheel zoom speed (50%..200%)
	{
		setting = "DistanceRateWheelFactor", variantFloat = 1.0,	
		nameLocID = 11166676, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.1, rangeMax = 2.0, tickFrequency = 0.01, telemetryName = "Zoom Speed",
		metaData =
		{
			{key = "ValueFormat", variantString ="Percentage"},
		},
	},
	-- Enable pan acceleration and smoothing
	{
		setting = "EnablePanAccelerationAndSmoothing", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11183427, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Enable Pan Acceleration",
	},
	-- Active mouse pan camera handler
	{
		setting = "ActiveMousePanHandler", variantString = "mouse_pan_default", valueStore = valueStoreUser,
		nameLocID = 11184022, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Mouse Button Pan Camera Style",
		list =
		{
			-- 0 = default
			{variantString = "mouse_pan_default", locNameID =11184020},
		},
		isDebug = true,
	},
	-- Active screen edge pan camera handler
	{
		setting = "ActiveScreenEdgePanHandler", variantString = "screen_edge_pan_default", valueStore = valueStoreUser,
		nameLocID = 11184023, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Screen Edge Pan Camera Style",
		list =
		{
			-- 0 = default
			{variantString = "screen_edge_pan_default", locNameID =11184020},
		},
		isDebug = true,
	},
	-- Active mouse button pan camera handler
	{
		setting = "ActiveKeyboardPanHandler", variantString = "keyboard_pan_default", valueStore = valueStoreUser,
		nameLocID = 11184024, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Keyboard Pan Camera Style",
		list =
		{
			-- 0 = default
			{variantString = "keyboard_pan_default", locNameID =11184020},
		},
		isDebug = true,
	},
	-- Mouse button pan direction
	{
		setting = "MouseButtonPanDirection", variantString = "reversed", valueStore = valueStoreUser,
		nameLocID = 11166677, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Mouse Button Pan Direction",
		list =
		{
			-- Reversed 
			{variantString = "reversed", locNameID = 11166678},
			-- Normal
			{variantString = "normal", locNameID = 11166679},
		},
		isDebug = true,
	},
	-- Mouse button pan speed (50%..200%)
	{
		setting = "MouseButtonPanSpeedFactor",	variantFloat = 1.0,	
		nameLocID = 11166680, 	dataTemplate = DT_Slider, 	uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.5, rangeMax = 2.0, tickFrequency = 0.01, telemetryName = "Mouse Button Pan Speed",
		metaData =
		{
			{key = "ValueFormat", variantString ="Percentage"},
		},
	},
	-- Edge Pan moves camera when mouse is on game window edge
	{
		setting = "EdgePan", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11149476, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Screen Edge Panning",
	},
	-- Disables Edge Panning while the player is Box Selecting
	{
		setting = "BoxSelectingDisablesEdgePan", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11266946, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Box Selecting Disables Screen Edge Panning",
	},
	-- Screen Edge Pan Acceleration
	{
		setting = "EdgePanAcceleration", variantFloat = 1.0, valueStore = valueStoreUser,
		nameLocID = 11166848, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0, rangeMax = 2.0, tickFrequency = 0.01, telemetryName = "Screen Edge Pan Speed",
		metaData =
		{
			{key = "ValueFormat", variantString ="Percentage"},
		},
	},
	-- Keyboard Pan Acceleration
	{
		setting = "KeyboardPanAcceleration",  variantFloat = 1.0, valueStore = valueStoreUser,
		nameLocID = 11166853, 	dataTemplate = DT_Slider, 	uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0, rangeMax = 2.0, tickFrequency = 0.01, telemetryName = "Keyboard Pan Speed",
		metaData =
		{
			{key = "ValueFormat", variantString ="Percentage"},
		}
	},
		-- Screen Edge Pan Speed
	{
		setting = "EdgePanSpeedFactor",  variantFloat = 1.0, valueStore = valueStoreUser,
		nameLocID = 11166848, 	dataTemplate = DT_Slider, 	uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.25, rangeMax = 2.0, tickFrequency = 0.01, telemetryName = "Screen Edge Pan Speed",
		metaData =
		{
			{key = "ValueFormat", variantString ="Percentage"},
		},
	},
	-- Keyboard Pan Speed
	{
		setting = "KeyboardPanSpeedFactor",  variantFloat = 1.0, valueStore = valueStoreUser,
		nameLocID = 11166853, 	dataTemplate = DT_Slider, 	uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.25, rangeMax = 2.0, tickFrequency = 0.01, telemetryName = "Keyboard Pan Speed",
		metaData =
		{
			{key = "ValueFormat", variantString ="Percentage"},
		}
	},
		-- Mouse Cursor Speed
	{
		setting = "MouseCursorSpeed",  variantFloat = 50, valueStore = valueStoreSystem,
		nameLocID = 11166870, 	dataTemplate = DT_Slider, 	uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0, rangeMax = 100.0, tickFrequency = 1.0, telemetryName = "Mouse Cursor Speed",
		isDebug = true
	},
	-- Mouse Clamp constrains the mouse cursor to the game window
	{	
		setting = "MouseClamp",  variantBool = true, valueStore = valueStoreSystem,
		nameLocID = 11149475, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Lock Mouse to Window",
	},
	-- Dynamic Training
	{
		setting = "DynamicTraining",  variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11166872, 	dataTemplate = "DynamicTraining", inGameDataTemplate = "DynamicTraining_InGame", 
		uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Dynamic Training",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183038"},
		}
	},
	-- Player colour
	{	
		setting = "PlayerColour", variantBool = true, valueStore = valueStoreUser, 
		nameLocID = 11159452, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Player Colors",
		list =
		{
			-- Unique 
			{variantBool = true, locNameID = 11166881},
			-- Team-Based 
			{variantBool = false, locNameID = 11166882},
		},
	},
	-- Box Select (drag)
	{
		setting = "BandboxSelect", variantKey = "", valueStore = valueStoreUser,
		nameLocID = 11166917, 	dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Box Select (drag)",
		list =
		{
			-- Smart 
			{variantKey = "", locNameID = 11166918},
			-- Villagers Only
			{variantKey = "villager", locNameID = 11166919},
			-- Military Only
			{variantKey = "military", locNameID = 11166920},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183037"},
		},
	},
		-- Show Game Duration Timer in HUD
	{
		setting = "ShowGameTimer", variantBool = false, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166633, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Show Game Duration Timer",
	},
	-- Show Player Scores in HUD
	{
		setting = "ShowPlayerScores", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166968, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Show Player Scores in HUD",
	},
	-- Can Garrison units using right click
	{
		setting = "RightClickGarrison", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11217565, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Right Click Garrison",
	},
	-- Show waypoint markers for single actions
	{
		setting = "SingleActionWaypointMarkers", variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11230613, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Single Action Waypoint Markers",
	},
	-- Queued Command Priority
	{
		setting = "QueuedCommandPriority", variantInt = 0, valueStore = valueStoreUser,
		nameLocID = 11254106, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Queued Command Priority",
		list =
		{
			{variantInt = 0, locNameID = 11254107, telemetryName = "Gathering"},
			{variantInt = 1, locNameID = 11254108, telemetryName = "Construction"},			
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11254109"},
		},
	},
	-- Attack Move Behaviour
	{
		setting = "AttackMoveBehaviour", variantInt = 0, valueStore = valueStoreUser,
		nameLocID = 11263752, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Attack Move Behaviour",
		list =
		{
			{variantInt = 0, locNameID = 11263756, telemetryName = "Default"},
			{variantInt = 1, locNameID = 11263757, telemetryName = "Legacy"},			
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11263758"},
		},
	},
	-- Global Build Queue Visibility
	{
		setting = "GlobalBuildQueueVisibility", variantInt = 0, valueStore = valueStoreUser,
		nameLocID = 11218849, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Global Build Queue Visibility",
		list =
		{
			{variantInt = 0, locNameID = 11218850, telemetryName = "Show All"},
			{variantInt = 1, locNameID = 11218851, telemetryName = "Show Upgrades Only"},
			{variantInt = 2, locNameID = 11218852, telemetryName = "Off"},
		}
	},
	-- Minimap Zoom Level
	{
		setting = "MinimapZoomLevel", variantFloat = 1.0, valueStore = valueStoreUser,
		nameLocID = 11245268, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Minimap Zoom Level",
		list =
		{
			{variantFloat = 1.0, locNameID = 11245269, telemetryName = "Normal Size"},
			{variantFloat = 1.25, locNameID = 11245270, telemetryName = "125% Zoom"},
			{variantFloat = 1.5, locNameID = 11245271, telemetryName = "150% Zoom"},
		}
	},
	--Campaign Difficulty
	{
		setting = "CampaignDifficulty", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 11166952, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Campaign Difficulty",
		list =
		{
			-- Story Mode
			{variantInt = 0, locNameID = 11204435, descLocID = 11204436, telemetryName = "Story"},
			-- Easy
			{variantInt = 1, locNameID = 11166953, descLocID = 11201419, telemetryName = "Easy"},
			-- Intermediate
			{variantInt = 2, locNameID = 11166954, descLocID = 11201427, telemetryName = "Intermediate"},
			-- Hard
			{variantInt = 3, locNameID = 11166955, descLocID = 11201428, telemetryName = "Hard"},
		}
	},
	--Rogue Mode Difficulty
	{
		setting = "RogueModeDifficulty", variantInt = 0, valueStore = valueStoreUser,
		nameLocID = 11166952, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Rogue Mode Difficulty",
		list =
		{
			-- Easiest
			{variantInt = 0, locNameID = 11269719, descLocID = 11269720, telemetryName = "Story"},
			-- Easy
			{variantInt = 1, locNameID = 11166953, descLocID = 11266774, telemetryName = "Easy"},
			-- Intermediate
			{variantInt = 2, locNameID = 11166954, descLocID = 11266775, telemetryName = "Intermediate"},
			-- Hard
			{variantInt = 3, locNameID = 11166955, descLocID = 11266776, telemetryName = "Hard"},
			{variantInt = 4, locNameID = 11162740, descLocID = 11266777, telemetryName = "Hardest"},
			{variantInt = 5, locNameID = 11250879, descLocID = 11266778, telemetryName = "Ridiculous"},
			{variantInt = 6, locNameID = 11250880, descLocID = 11266779, telemetryName = "Outrageous"},
			{variantInt = 7, locNameID = 11250881, descLocID = 11266780, telemetryName = "Absurd"},
		}
	},
	--Rogue Mode Perks
	--Whether or not use perks in rogue mode
	{
		setting = "RogueModePerks", variantBool = true, valueStore = valueStoreUser,
		dataTemplate = UT_Bool, uiType = UT_Bool, telemetryName = "RogueModePerks"
	},
	--Whether or not campaign difficulty has ever been changed from the default
	{
		setting = "CampaignDifficultySet", variantBool = false, valueStore = valueStoreUser,
		dataTemplate = "HiddenSetting", uiType = UT_Bool, telemetryName = "CampaignDifficultySet"
	},
	-- Campaign Auto-Save
	{
		setting = "CampaignAutoSave",  variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11166956, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Campaign Auto-Save",
	},
	-- Bring Game Window to Front When Ready
	{
		setting = "GameWindowActiveWhenLoaded",  variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11166957, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		isDebug = true, telemetryName = "Bring Game Window to Front When Ready",
	},
	-- Age Up event
	{
		setting = "eventAgeUp", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166978, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Age Up",
	},
	-- Building Complete event
	{
		setting = "eventBuildingComplete", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166980, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Building Complete",
	},
	-- Unit Complete event
	{
		setting = "eventUnitComplete", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166981, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Unit Complete",
	},
	-- Upgrade Complete event
	{
		setting = "eventUpgradeComplete", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166982, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Upgrade Complete"
	},
	-- Under Attack event
	{
		setting = "eventUnderAttack", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166983, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Under Attack",
	},
	-- Population Cap event
	{
		setting = "eventPopulationCap", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166984, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Population Capacity",
	},
	-- Unit found event
	{
		setting = "eventUnitFound", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166985, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Unit found",
	},
	-- Object Found event
	{
		setting = "eventObjectFound", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166986, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Object found",
	},
	-- Major Game Mode Objectives event
	{
		setting = "eventMajorGameModeObjectives", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166987, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Major Game Mode Objectives",
	},
	-- Minor Game Mode Objectives event
	{
		setting = "eventMinorGameModeObjectives", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166988, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Minor Game Mode Objectives",
	},
	-- Minor Campaign Objectives event
	{
		setting = "eventMinorCampaignObjectives", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166989, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Minor Campaign Objectives",
	},
	-- Healthbars
	{
		setting = "HealthBarVisibilityMode", variantInt = 0, valueStore = valueStoreUser,
		nameLocID = 11168715, 	dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Healthbars",
		list =
		{
			-- Smart
			{variantInt = 0, locNameID = 11166999},
			-- Selection Only
			{variantInt = 1, locNameID = 11167003},
			-- Always On
			{variantInt = 2, locNameID = 11167001},
			-- Always Off, except for some special states: tagged, reloading, progress, grouped, etc.
			{variantInt = 3, locNameID = 11167002},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183039"},
		}
	},
	-- Construction Progress Bars
	{
		setting = "ConstructionProgressVisibilityMode", variantInt = 2, valueStore = valueStoreUser,
		nameLocID = 11167004, 	dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Construction Progress Bars",
		list =
		{
			-- Always On
			{variantInt = 2, locNameID = 11167001},
			-- Selection Only,
			{variantInt = 1, locNameID = 11167003},
			-- Always Off
			{variantInt = 3, locNameID = 11167002},
		},
	},
	-- Landmark Construction Progress Visibility
	{
		setting = "LandmarkConstructionProgressVisibilityMode", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11184487, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both, 
		isDebug = true, telemetryName = "Display Landmark construction progress widget",
	},
	-- District Tier Icons
	{
		setting = "DistrictTierIconVisibilityMode", variantInt = 2, valueStore = valueStoreUser,
		nameLocID = 11167005, 	dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "District Tier Icons",
		list =
		{
			-- Always On
			{variantInt = 2, locNameID = 11167001},
			-- Selection Only,
			{variantInt = 1, locNameID = 11167003},
			-- Always Off
			{variantInt = 3, locNameID = 11167002},
		},
		isDebug = true		
	},
	-- Building Grid Overlay
	{
		setting = "BuildingGridOverlay", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 11167006, 	dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Building Grid Overlay",
		list =
		{
			-- Always On
			{variantInt = 0, locNameID = 11167001},
			-- While Placing Buildings
			{variantInt = 1, locNameID = 11166999},
			-- Off
			{variantInt = 2, locNameID = 2901},
		},
		isDebug = true
	},
	-- Control Group Shortcuts
	{
		setting = "ShowControlGroup", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11167007, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Control Group Shortcuts",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183040"},
		},
	},
	-- Idle Villager Icons
	{
		setting = "ShowIdleVillagerIcons", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11167008, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Idle Villager Icons",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183048"},
		},
	},
		-- Condensed Victory Objectives
	{
		setting = "ShowCondensedVictoryObjectives", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11261865, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Condensed Victory Objectives",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11261875"},
		},
	},
	-- Minimap Buildings
	{
		setting = "MinimapBuildings", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11167011, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Buildings",
	},
	-- Minimap Units
	{
		setting = "MinimapUnits", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11167012, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Units"
	},
	-- Minimap Resources
	{
		setting = "MinimapResources", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11167013, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Resources",
	},
	-- Minimap Objects
	{
		setting = "MinimapObjects", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11167014, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Objects",
	},
	-- Minimap Ping Notifications
	{
		setting = "MinimapPingNotifications", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11167015, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Ping Notifications",
	},
	-- Minimap Build Notifications
	{
		setting = "MinimapBuildNotifications", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11167016, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Build Notifications",
	},
	-- Minimap Attack Notifications
	{
		setting = "MinimapAttackNotifications", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11167017, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Attack Notifications",
	},
	-- LDR Gamma
	{
		setting = "LdrGamma",	variantFloat = 0.5,	canPreview = true, 
		nameLocID = 22020, 	dataTemplate = DT_Slider, 	uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Brightness",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"},
			{key = "TooltipLocKey", variantString = "$11183050"},
		}
	},
	-- HDR Gamma
	{
		setting = "HdrGamma",	variantFloat = 0.5,	canPreview = true, 
		nameLocID = 11199800, 	dataTemplate = DT_Slider, 	uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0, rangeMax = 1.0, tickFrequency = 0.01,
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"}
		},
		isDebug = true,
	},
	-- Hdr Maximum Brightness
	-- Setting value is in the range of [rangeMin, rangeMax] nit
	-- UI ( HDRSetttings.xaml) maps [rangeMin, rangeMax] to the normalized range [0, 100]
	-- if rangeMin or rangeMax is modified, update HDRBrightnessConverter.MinNit or HDRBrightnessConverter.MaxNit in HDRSetttings.xaml accordingly.
	{
		setting = "HdrMaxBrightness",	variantFloat = 10000,	canPreview = true, 
		nameLocID = 11199801, 	dataTemplate = DT_Slider, 	uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 400, rangeMax = 10000,
		isDebug = true,
	},
	-- Model quality (0..4)
	{	
		setting = "ModelDetail", variantUInt = 0, canOverrideDefault = true, 
		nameLocID = 11167053, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Geometry Detail",
		list = 
		{
			-- Low
			{variantUInt = 0, locNameID = 2905},
			-- Medium
			{variantUInt = 1, locNameID = 2904},
			-- High
			{variantUInt = 2, locNameID = 2903},
			-- Ultra
			{variantUInt = 3, locNameID = 11204620},
			-- Maximum
			{variantUInt = 4, locNameID = 2957},
		}
	},	
	-- Shadow filter quality, maps to PCF/PCSS taps
	-- Autodetect should set this through GraphicsQuality.
	{
		setting = "ShadowFilter", variantUInt = 2,
		nameLocID = 11167052, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Shadow Distance",
		list = 
		{
			-- Minimum
			{variantUInt = 0, locNameID = 2956},
			-- Low
			{variantUInt = 1, locNameID = 2905},
			-- Medium
			{variantUInt = 2, locNameID = 2904},
			-- High
			{variantUInt = 3, locNameID = 2903},
			-- Ultra
			{variantUInt = 4, locNameID = 11196180},
			-- Maximum
			{variantUInt = 5, locNameID = 2957},
		}
	},	
	-- WorldViewQuality (2 is 1:1, 3 is 1.25:1, 4 is 1.5:1)
	{
		setting = "WorldViewQuality", variantUInt = 2, canOverrideDefault = true,
		nameLocID = 11196219, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "WorldViewQuality",
		list = 
		{
			-- Minimum
			{variantUInt = 0, locNameID = 2956},
			-- Low
			{variantUInt = 1, locNameID = 2905},
			-- Medium
			{variantUInt = 2, locNameID = 2904},
			-- High
			{variantUInt = 3, locNameID = 2903},
			-- Ultra
			{variantUInt = 4, locNameID = 11196180},
		}
	},	
	-- Occlusion
	{
		setting = "ShowUnitOcclusion", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11198597, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Show Unit Occlusion",
	},
	-- Reflections (1=everything, 0=just the sky)
	-- Autodetect should set this through GraphicsQuality.
	{
		setting = "Reflections", variantUInt = 1,
		nameLocID = 11196223, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Reflections",
		list = 
		{
			-- Low
			{variantUInt = 0, locNameID = 2905},
			-- High
			{variantUInt = 1, locNameID = 2903},
		}
	},	
	-- Terrain detail (0=low, 1=med, 2=high, 3=ultra)
	-- Autodetect should set this through GraphicsQuality.
	{
		setting = "TerrainDetail", variantUInt = 3,
		nameLocID = 11196224, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "TerrainDetail",
		list = 
		{
			-- Minimum
			{variantUInt = 0, locNameID = 2956},
			-- Low
			{variantUInt = 1, locNameID = 2905},
			-- Medium
			{variantUInt = 2, locNameID = 2904},
			-- High
			{variantUInt = 3, locNameID = 2903},
		}
	},	
	-- Effects fidelity, this also affects fog on fx (0 = distance fog, 1 and higer = volumetric fog)
	-- Autodetect should set this through GraphicsQuality.
	{
		setting = "EffectsFidelity", variantUInt = 2,
		nameLocID = 11196178, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "EffectsFidelity",
		list = 
		{
			-- Low
			{variantUInt = 0, locNameID = 2905},
			-- Medium
			{variantUInt = 1, locNameID = 2904},
			-- High
			{variantUInt = 2, locNameID = 2903},
			-- Ultra
			{variantUInt = 3, locNameID = 11196180},
		}
	},
	-- Effects density
	-- Autodetect should set this through GraphicsQuality.
	{
		setting = "EffectsDensity", variantUInt = 2,
		nameLocID = 11196177, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "EffectsDensity",
		list = 
		{
			-- Low
			{variantUInt = 0, locNameID = 2905},
			-- Medium
			{variantUInt = 1, locNameID = 2904},
			-- High
			{variantUInt = 2, locNameID = 2903},
			-- Ultra
			{variantUInt = 3, locNameID = 11196180},
		}
	},
	-- The default value of setting is used by autodetect to communicate to the game that the user's system is gen 7. Setting the default value of this to true enables some gen 7 warnings and dialogues (i.e. warning when more than 4 players are in a match for performance reasons).
	{
		setting = "gen7", variantBool = false, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, -- "Error"
		dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	-- VRS
	{
		setting = "VariableRateShading", variantBool = true, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	-- VRS Threshold
	{
		setting = "VariableRateShadingThreshold", variantFloat = 0.06, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	
	-- Texture Streaming
	{
		setting = "TextureStreamingEnabled", variantBool = false, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	{
		setting = "TextureStreamingMinMipCount", variantUInt = 5, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	{
		setting = "TextureStreamingMaxMipCount", variantUInt = 10, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	{
		setting = "TextureStreamingMaxMemoryUsage", variantUInt = 128, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	{
		setting = "TextureStreamingMaxCriticalCachedMemory", variantUInt = 32, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	{
		setting = "TextureStreamingMaxConcurrentStreams", variantUInt = 32, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	{
		setting = "TextureStreamingCoverageBias", variantFloat = 2.0, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},

	
	-- Dynamic resolution
	{
		setting = "DynamicResolutionScaleMin", variantFloat = 0.6, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	{
		setting = "DynamicResolutionFramesBeforeDownsample", variantUInt = 15, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	{
		setting = "DynamicResolutionFramesBeforeUpsample", variantUInt = 25, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	{
		setting = "DynamicResolutionDesiredFrameTime", variantFloat = 32.0, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	{
		setting = "DynamicResolutionAllowedFrameTimeVariance", variantFloat = 1.5, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	{
		setting = "DynamicResolutionAdjustmentFactor", variantFloat = 1.0, canOverrideDefault = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},

	-- Dynamic VSync
	{
		setting = "DynamicVerticalSync", variantBool = false, canOverrideDefault = true, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},
	{
		setting = "DynamicVerticalSyncThreshold", variantFloat = 4.0, canOverrideDefault = true, canPreview = false,
		nameLocID = 400, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true
	},

	-- Misc/control options
	-- Squad event cues
	{
		setting = "ShowNonCriticalEventCues", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11196229, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "ShowNonCriticalEventCues",
	},
	-- Show Paths
	{
		setting = "ShowPaths", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11196230, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "ShowPaths",
	},
	-- Classic XP Kickers
	{
		setting = "ClassicXPKickers", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11196231, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "ClassicXPKickers",
	},
	-- Show subtitles
	{
		setting = "ShowHUDSubtitles", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11196232, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "ShowHUDSubtitles",
	},
	-- Show unit description
	{
		setting = "ShowUnitDescription", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11196233, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "ShowUnitDescription",
	},
	-- Advanced Orders
	{
		setting = "AdvancedOrders", variantBool = false, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11196236, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "AdvancedOrders",
	},
	-- Show damage flashing
	{
		setting = "ShowDamageFlashing", variantBool = false, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11196237, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "ShowDamageFlashing",
	},
	-- Enable the chat filter system
	{
		-- not exposed in Cardinal - set isDebug, default true, valueStoreSystem
		setting = "FilterChat", variantBool = true, valueStore = valueStoreSystem, canPreview = false,
		nameLocID = 11196238, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "FilterChat",
	},
	-- When to display decorators (0 = all the time, 1 = only on selected things, 2 = only on damaged or selected things, 3 = always off)
	{	
		setting = "DecoratorVisibility", variantUInt = 0,
		nameLocID = 11196239, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "DecoratorVisibility",
		list = 
		{
			-- Always On
			{variantUInt = 0, locNameID = 11097403},
			-- Selected 
			{variantUInt = 1, locNameID = 11095343},
			-- Selected or Damaged
			{variantUInt = 2, locNameID = 11095344},
			-- Always Off
			{variantUInt = 3, locNameID = 11167002},
		}
	},
	-- When to display capture points (0 = all the time, 1 = only when the thing is selected)
	{	
		setting = "CaptureZoneVisibility", variantUInt = 0,
		nameLocID = 11196241, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "CaptureZoneVisibility",
		list = 
		{
			-- Always On
			{variantUInt = 0, locNameID = 11097403},
			-- Selected 
			{variantUInt = 1, locNameID = 11095343},
		}
	},
	-- Show custom items e.g. decals, skins
	{
		setting = "ShowCustomItems", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11196242, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "ShowCustomItems",
	},
	-- Always show build progress
	{
		setting = "BuildProgressAlwaysOn", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11196243, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "BuildProgressAlwaysOn"
	},
	-- Command card on the right side of the HUD layout
	{
		setting = "LayoutCommandCardRight", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11150880, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "LayoutCommandCardRight",
	},
	-- USS sorting style
	{	
		setting = "USSSortMethod", variantUInt = 0,
		nameLocID = 11196246, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "USSSortMethod",
		list = 
		{
			-- Build Time
			{variantUInt = 0, locNameID = 11196247},
			-- Squad Pop Cap 
			{variantUInt = 1, locNameID = 11196248},
		}
	},
	-- Selection silhouette style
	{	
		setting = "SelectionSilhouette", variantUInt = 2,
		nameLocID = 11196260, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "SelectionSilhouette",
		list = 
		{
			-- Maximum
			{variantUInt = 0, locNameID = 2957},
			-- Fade to Value 
			{variantUInt = 1, locNameID = 11196261},
			-- Always Off
			{variantUInt = 2, locNameID = 11167002},
		}
	},
	
	
	-- ---------------Online settings-----------------
	-- Voice Chat
	{	
		setting = "UseVoiceChat",  variantBool = false, valueStore = valueStoreUser, canPreview = true,
		nameLocID = 11192947, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = false, telemetryName = "Voice Chat", uiModelTypeOverride="VoiceChatSystemConfigSettingModel",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11249161"},
		},
	},
	-- Voice Chat Method
	{   
		setting = "VoiceChatMethod", variantUInt = 0, valueStore = valueStoreUser,
		nameLocID = 11193167, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Voice Chat Method",
		list = 
		{
			-- Push to Talk 
			{variantUInt = 0, locNameID = 11193174}, 
			-- Voice Activated
			{variantUInt = 1, locNameID = 11193175},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11249163"},
		},
		isDebug = false
	},
	-- (Audio) Output Device <- PC Only
	-- This should be populated by C++ code	
	{
		setting = "AudioOutputDevice", variantString = "", canOverrideDefault = true, valueStore = valueStoreSystem,
		nameLocID = 11258152, dataTemplate = DT_AudioOutputDevice, uiType = UT_Custom, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Audio Output Device",
	},
	-- (Audio) Input Device <- PC Only
	-- This should be populated by C++ code
	{
		setting = "AudioInputDevice", variantString = "", canOverrideDefault = true, valueStore = valueStoreSystem,
		nameLocID = 11258151, dataTemplate = DT_AudioInputDevice, uiType = UT_Custom, uiAvailability = UA_Both, hardwareAvailability = HA_PC,
		telemetryName = "Audio Input Device",
	},
	-- Mute Microphone
	{	
		setting = "MuteMicrophone",  variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11248594, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = false, telemetryName = "Mute Microphone",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11249166"},
		},
	},
	-- Chat Timestamps
	{	
		setting = "ShowChatTimeStamp",  variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11167095, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Chat Timestamps",
	},
	-- Display chat messages for pings
	{	
		setting = "PingChatMessages",  variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11219903, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Ping Chat Messages",
	},
	-- Toggle taunts
	{	
		setting = "EnableTaunts",  variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11229012, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Enable Taunts",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11231316"},
		},
	},
	-- Auto-Select Server Region
	{	
		setting = "AutoSelectServerRegion",  variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11170339, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Automatically pick regions based on my location",
	},
	-- Allow Messages
	-- See ChatManager.cpp for implementation
	{
		setting = "AllowMessages", variantUInt = 0, valueStore = valueStoreUser, uiAvailability = UA_Both,
		nameLocID = 11167098, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Allow Messages",
		list = 
		{ 
			-- From Everyone
			{variantUInt = 0, locNameID = 11167103}, 
			-- From Friends
			{variantUInt = 1, locNameID = 11167104},
			-- From Nobody
			{variantUInt = 2, locNameID = 11167105},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001276"},
		},
	},
	-- Allow Friend Requests
	-- See RelationshipManager.cpp for implementation
	{
		setting = "AllowFriendRequests", variantUInt = 0, valueStore = valueStoreUser, uiAvailability = UA_Both,
		nameLocID = 11167099, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Allow Friend Requests",
		list = 
		{ 
			-- From Everyone
			{variantUInt = 0, locNameID = 11167103}, 
			-- From System Friends
			{variantUInt = 1, locNameID = 11167106},
			-- From Nobody
			{variantUInt = 2, locNameID = 11167105},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001277"},
		},
	},
	-- OnlinePresence
	{
		setting = "OnlinePresence", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11204584, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Online Presence",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11204585"},
		},
	},
	-- BlockUGC
	{
		setting = "BlockUGC", variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11221146, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		platformAvailability = PA_Steam, telemetryName = "Block community mods",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11221147"},
		},
	},
	
	
	-- ---------------Accessibility settings-----------------
	-- Customize Game Colors
	{
		setting = "CustomizeGameColors",  variantUInt = 0, valueStore = valueStoreUser,
		nameLocID = 11168766, dataTemplate = "ColorPicker", uiType = UT_Custom, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "CustomizeGameColors",
	},
	-- Unique Minimap Player Icons
	{
		setting = "UniqueMinimapPlayerIcons",  variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11167124, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Unique Minimap Player Icons",
	},
	-- Sliding Notifications
	{
		setting = "SlidingNotifications",  variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11198732, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Slide Out Notifications",
	},
	-- Strong / High Contrast
	{
		-- though variantBool is set to false, if strong_high_contrast_set_by_ftue is false the Windows Ease Of Access 
		-- setting is used at system start time - this default of `false` is used for settings modal "Reset" action
		setting = "StrongHighContrast",  variantBool = false, valueStore = valueStoreSystem,
		nameLocID = 11182712, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Strong/High Contrast Mode",
	},
	-- UI Text Scale
	{
		setting = "UIScale", 		variantFloat = 1.0,
		nameLocID = 11167121, 	dataTemplate = DT_ComboBox, uiType = UT_List, canPreview = true,
		telemetryName = "UI Text Scale",
		list = 
		{ 
			-- 100%
			{variantFloat = 1.0, 	locNameID = 11167140}, 
			-- 105%
			--{variantFloat = 1.05, 	locNameID = 11167141},
			-- 110%
			--{variantFloat = 1.1, 	locNameID = 11167142},
			-- 115%
			--{variantFloat = 1.15, 	locNameID = 11167143},
			-- 120%
			--{variantFloat = 1.2, 	locNameID = 11167144},
			-- 125%
			{variantFloat = 1.25, 	locNameID = 11167145},
			-- 130%
			--{variantFloat = 1.30, 	locNameID = 11197425},
			-- 135%
			--{variantFloat = 1.35, 	locNameID = 11197426},
			-- 140%
			--{variantFloat = 1.40, 	locNameID = 11197427},
			-- 145%
			--{variantFloat = 1.45, 	locNameID = 11197428},
			-- 150%
			{variantFloat = 1.50, 	locNameID = 11197429},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183052"},
		},
	},
	-- UI Text Scale xbox
	{
		xboxOverride = true, setting = "UIScale", variantFloat = 1.0, valueStore = valueStoreUser,
		nameLocID = 11167121, 	dataTemplate = DT_ComboBox, uiType = UT_List, canPreview = true,
		telemetryName = "UI Text Scale",
		list = 
		{ 
			-- 100%
			{variantFloat = 1.0, 	locNameID = 11167140}, 
			-- 105%
			--{variantFloat = 1.05, 	locNameID = 11167141},
			-- 110%
			--{variantFloat = 1.1, 	locNameID = 11167142},
			-- 115%
			--{variantFloat = 1.15, 	locNameID = 11167143},
			-- 120%
			--{variantFloat = 1.2, 	locNameID = 11167144},
			-- 125%
			{variantFloat = 1.25, 	locNameID = 11167145},
			-- 130%
			--{variantFloat = 1.30, 	locNameID = 11197425},
			-- 135%
			--{variantFloat = 1.35, 	locNameID = 11197426},
			-- 140%
			--{variantFloat = 1.40, 	locNameID = 11197427},
			-- 145%
			--{variantFloat = 1.45, 	locNameID = 11197428},
			-- 150%
			{variantFloat = 1.50, 	locNameID = 11197429},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183052"},
		},
	},
	-- Cursor Scale
	{
		setting = "CursorScale", 		variantFloat = 1.0,
		nameLocID = 11167122, 	dataTemplate = DT_ComboBox, uiType = UT_List, canPreview = true,
		telemetryName = "Cursor Scale",
		list = 
		{ 
			-- 100%
			{variantFloat = 1.0, 	locNameID = 11167140}, 
			-- 125%
			{variantFloat = 1.25, 	locNameID = 11167145},
			-- 150%
			{variantFloat = 1.5, 	locNameID = 11167146},
			-- 200%
			{variantFloat = 2.0, 	locNameID = 11167147},
		},
		isDebug = true,
	},
	-- Subtitle Scale
	{
		setting = "CaptionScale", 		variantFloat = 1.0,
		nameLocID = 11167123, 	dataTemplate = DT_ComboBox, uiType = UT_List, canPreview = true,
		telemetryName = "Subtitle Scale",
		list = 
		{
			-- 100%
			{variantFloat = 1.0, 	locNameID = 11167140}, 
			-- 125%
			{variantFloat = 1.25, 	locNameID = 11167145},
			-- 150%
			{variantFloat = 1.5, 	locNameID = 11167146},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183053"},
		},
	},
	-- Subtitle Scale xbox
	{
		xboxOverride = true, setting = "CaptionScale", 		variantFloat = 1.0, valueStore = valueStoreUser,
		nameLocID = 11167123, 	dataTemplate = DT_ComboBox, uiType = UT_List, canPreview = true,
		telemetryName = "Subtitle Scale",
		list = 
		{
			-- 100%
			{variantFloat = 1.0, 	locNameID = 11167140}, 
			-- 125%
			{variantFloat = 1.25, 	locNameID = 11167145},
			-- 150%
			{variantFloat = 1.5, 	locNameID = 11167146},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183053"},
		},
	},
	-- Subtitle
	{
		setting = "SubtitleVisibility", 		variantUInt = 2,
		nameLocID = 11197436, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Subtitles",
		list = 
		{ 
			-- Movie and Game Speech
			{variantUInt = 0, 	locNameID = 11167148}, 
			-- Movie Speech Only
			{variantUInt = 1, 	locNameID = 11167149},
			-- Off 
			{variantUInt = 2, 	locNameID = 2901},
		},
	},
	-- Subtitle xbox
	{
		xboxOverride = true, setting = "SubtitleVisibility", variantUInt = 2, valueStore = valueStoreUser,
		nameLocID = 11197436, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Subtitles",
		list = 
		{ 
			-- Movie and Game Speech
			{variantUInt = 0, 	locNameID = 11167148}, 
			-- Movie Speech Only
			{variantUInt = 1, 	locNameID = 11167149},
			-- Off 
			{variantUInt = 2, 	locNameID = 2901},
		},
	},
	-- Subtitle Position
	{
		setting = "SubtitlePosition", 		variantUInt = 1,
		nameLocID = 11167126, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Position",
		list = 
		{ 
			-- Top
			{variantUInt = 0, 	locNameID = 11167150}, 
			-- Bottom 
			{variantUInt = 1, 	locNameID = 11167151},
			-- Left
			{variantUInt = 2, 	locNameID = 11167152},
			-- Right
			{variantUInt = 3, 	locNameID = 11167153},
		},
		isDebug = true,
	},
	-- Subtitle Font
	{
		setting = "SubtitleFont", 		variantUInt = 0,
		nameLocID = 11167127, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Font",
		list = 
		{ 
			-- AoE IV
			{variantUInt = 0, 	locNameID = 11167154}, 
			-- Serif 
			{variantUInt = 1, 	locNameID = 11167155},
			-- Sans-Serif
			{variantUInt = 2, 	locNameID = 11167156},
		},
		isDebug = true,
	},
	-- Font Color
	{
		setting = "SubtitleFontColor", 		variantUInt = 0,
		nameLocID = 11167128, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Font Color",
		list = 
		{ 
			-- White
			{variantUInt = 0, 	locNameID = 11167157}, 
		},
		isDebug = true,
	},
	-- Background  Color
	{
		setting = "SubtitleBackgroundColor", variantUInt = 0, valueStore = valueStoreUser,
		nameLocID = 11167129, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Background Color",
		list = 
		{ 
			-- White
			{variantUInt = 0, 	locNameID = 11167157}, 
		},
		isDebug = true,
	},
	-- Screen Shake Effect
	{
		setting = "ScreenShakeEffect", 		variantUInt = 0,
		nameLocID = 11167131, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Screen Shake Effect",
		list = 
		{ 
			-- On
			{variantUInt = 0, 	locNameID = 2900},
			-- Reduced Motion
			{variantUInt = 1, 	locNameID = 11167159},
			-- Off
			{variantUInt = 2, 	locNameID = 2901},
		},
		isDebug = true,
	},
	-- Dynamic Camera
	{
		setting = "DynamicCamera", 		variantUInt = 0,
		nameLocID = 11167132, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Dynamic Camera",
		list = 
		{ 
			-- On
			{variantUInt = 0, 	locNameID = 2900},
			-- Reduced Motion
			{variantUInt = 1, 	locNameID = 11167159},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183054"},
		},
		isDebug = true,
	},
	-- Button Hold Timing
	{
		setting = "ButtonHoldTiming", variantFloat = 3.0, valueStore = valueStoreUser,
		nameLocID = 11167130, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Button Hold Timing",
		list = 
		{ 
			-- 10s
			{variantFloat = 10.0, 	locNameID = 11167160}, 
			-- 5s
			{variantFloat = 5.0, 	locNameID = 11167161},
			-- 3s
			{variantFloat = 3.0, 	locNameID = 11167194},
			-- 1s
			{variantFloat = 1.0, 	locNameID = 11167162},
			-- Off
			{variantFloat = 0.0, 	locNameID = 2901},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183055"},
		},
		isDebug = true,
	},
	-- Reduce Flashes
	{
		setting = "ReduceFlashes",  variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11167133, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Reduce Flashes",
	},
	-- Display Keyboard Chat Icon
	{
		setting = "DisplayKeyboardChatIcon",  variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11167135, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Display Keyboard Chat Icon",
	},
	-- Display No Audio Icon
	{
		setting = "DisplayNoAudioIcon",  variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11167136, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Display No Audio Icon",
	},
	--  Read Incoming Chat Messages
	{
		setting = "ReadIncomingTextChat",  variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11192095, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Read Incoming Chat Messages",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11192097"},
		}
	},
	-- UI Narration
	{
		setting = "UIElementNarration",  variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11167137, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "UI Narration", canPreview = true,
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183056"},
		}
	},
	-- Text-To-Speech
	{
		setting = "TextToSpeechForChatMessagesPc", valueStore = valueStoreUser,
		nameLocID = 11167138, dataTemplate = "DescriptionTextOnly", uiType = UT_Custom, uiAvailability = UA_Both,
		descLocID = 11183057, telemetryName = "Text-To-Speech for Chat Messages PC",
	},
	-- Speech-To-Text
	{
		setting = "SpeechToText",  variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11167139, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Speech-To-Text",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183058"},
		},
	},
	-- Skeletal Animation Quality
	{
		setting = "SkeletalAnimationLod", 	variantUInt = 1, canOverrideDefault = true, uiAvailability = UA_Both,
		nameLocID = 0, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "SkeletalAnimationLod",
		list = 
		{ 
			-- High
			{variantUInt = 0, locNameID = 0}, 
			-- Med 
			{variantUInt = 1, locNameID = 0},
			-- Low
			{variantUInt = 2, locNameID = 0},
		},
		isDebug = true,
	},

	-- ---------------Platform Overrides-----------------
	-- Force use of simple draw style for shadow
	{
		setting = "UseOnlyLowShadowDrawStyle",
		variantBool = false, 
		canPreview = true,
		canOverrideDefault = true
	},
	-- Force near and far shadow map cascade sizes independently.
	-- Value of 0 will depenend on the quality setting.
	{
		setting = "NearShadowMapSizeOverride",
		variantUInt = 0, 
		canPreview = true,
		canOverrideDefault = true
	},
	-- Force near and far shadow map cascade sizes independently.
	-- Value of 0 will depenend on the quality setting.
	{
		setting = "FarShadowMapSizeOverride",
		variantUInt = 0, 
		canPreview = true,
		canOverrideDefault = true
	},
	-- Overrides the shadow cascade number
	-- Value of -1 will depenend on the quality setting.
	{
		setting = "ShadowCascadeOverride",
		variantInt = -1, 
		canPreview = true,
		canOverrideDefault = true
	},
	-- Overrides the water reflection settings to disable water reflections entirely if enabled.
	{
		setting = "WaterReflectionsDisableOverride",
		variantBool = false, 
		canPreview = true,
		canOverrideDefault = true
	},
	
	-- ---------------Capture Tool Overrides-----------------
	-- FX Force Spawn Offscreen
	{
		setting = "FXForceSpawnOffscreen",
		variantBool = false, 
		canPreview = true,
		canOverrideDefault = true
	},
	-- Use Only Single Cascading Shadows
	{
		setting = "UseOnlySingleCascadingShadows",
		variantBool = false, 
		canPreview = true,
		canOverrideDefault = true
	},
	-- Terrain Set LOD
	{
		setting = "TerrainLod",
		variantInt = -1, 
		canPreview = true,
		canOverrideDefault = true
	},
	-- Fixed Shadow resolution
	-- Value of -1 will depend on the "Shadows" Quality setting
	{
		setting = "shadowSize",
		variantInt = -1, 
		canPreview = true,
		canOverrideDefault = true
	},

	-- ShadowMap Toggle Distance Override
	-- The override value will be the index used in the metadata, such as "0"
	-- In the metadata, it's a pattern of setting which ShadowMap enum to affect
	-- and another metadata to specify the value of the toggle
	-- ShadowMap metadata is prefixed with "ShadowMap" followed by the index ("ShadowMap0")
	-- ShadowMap toggle is a boolean ("Value0")
	-- ShadowMaps enum 	Far = 0, Near = 1, Point = 2	
	{
		setting = "ShadowMapToggleDistanceOverride",	
		variantUInt = 0,
		canPreview = true,
		canOverrideDefault = true,
		metaData = 
		{
			{key = "ShadowMap0", variantUInt = 0},
			{key = "Value0", variantBool = false},
			{key = "ShadowMap1", variantUInt = 0},
			{key = "Value1", variantBool = true},
		}
	}, 
	
	-- ShadowMap Set Distance Override (if overriden)
	-- The override value will be the index used in the metadata, such as "0"
	-- In the metadata, it's a pattern of setting which ShadowMap enum to affect
	-- and two metadata to specify the start/end values for the distance
	-- ShadowMap metadata is prefixed with "ShadowMap" followed by the index ("ShadowMap0")
	-- ShadowMap distance are two metadata, one "Start" and one "End" ("Start0" + "End0")
	-- ShadowMaps enum 	Far = 0, Near = 1, Point = 2	
	{
		setting = "ShadowMapSetDistanceOverride",	
		variantUInt = 0,
		canPreview = true,
		canOverrideDefault = true,
		metaData = 
		{
			-- Nothing defined for default value 0, since the overrides are disabled
			-- in "ShadowMapToggleDistanceOverride"

			{key = "ShadowMap1", variantUInt = 0},
			{key = "Start1", variantFloat = 0.0},
			{key = "End1", variantFloat = 400.0},			
		}
	},

	-- Tooltip Delay
	{
		setting = "TooltipDelay", variantFloat = 0.0, valueStore = valueStoreUser, canPreview = true,
		nameLocID = 11195003, 	dataTemplate = DT_Slider, 	uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 500.0, tickFrequency = 10.0,		
		isDebug = true, telemetryName = "Command Card Button Tooltip Delay (in milliseconds)",
	},

	-- Show Leader Crown
	{
		setting = "ShowLeaderCrown",  variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11196616, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Show Leader Crown",
	},
	
	-- Show Can Issue Result
	{
		setting = "ShowCanIssueResult",  variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11196632, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Show Can Issue Result",
	},
	{
		setting = "SelectionBoxOpacity", variantFloat = 1.0, dataTemplate = DT_Slider, uiType = UT_Range,
		rangeMin = 0, rangeMax = 1.0, tickFrequency = 0.01, valueStore = valueStoreSystem, nameLocID = 11198538,
		telemetryName = "Selection Box Opacity",
		metaData =
		{
			{key = "ValueFormat", variantString = "Lerp"},
			{key = "LerpMax", variantFloat = 100.0},
			{key = "LerpMin", variantFloat = 0.0},
		}
	},

	
	-- Move Action Spawning Chance (0..100)
	{	
		setting = "MoveActionSpawningChance", variantFloat = 1.0,
		nameLocID = 11198595, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Move Action Spawning Chance",
		metaData =
		{
			{key = "ValueFormat", variantString ="Percentage"},
		},
		isDebug = true
	},
	
	-- Show Formation Action
	{
		setting = "ShowFormationAction",  variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11198596, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = true, telemetryName = "Show Formation Action",
	},

	---------------------------------------------------
	-----------------Xbox Settings---------------------
	---------------------------------------------------
	
	-----------------Xbox Development---------------------

	-- Marquee Acceleration Is Active
	{
		setting = "MarqueeAccelerationIsActive", variantBool = false, valueStore = valueStoreUser,
		nameLocID = 999124, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Marquee Acceleration Is Active",
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$1001102"},
		},
	},
	
	-- Controller Button Hold Time
	{
		setting = "ControllerButtonHoldTime", variantFloat = 0.29, valueStore = valueStoreUser,
		nameLocID = 999077, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.2, rangeMax = 0.8, tickFrequency = 0.05, telemetryName = "Controller Button Hold Time",
		metaData =
		{
			{key = "ValueFormat", variantString ="Lerp"},
			{key = "LerpMax", variantFloat = 100.0},
			{key = "LerpMin", variantFloat = 0.0},
		},
	},

	-- Sticky Units is Active
	{
		setting = "StickyUnitsIsActive", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 999112, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Loose Reticule Is Active",
	},

	-- Recentralise On Full Pan is Active
	{
		setting = "RecentraliseOnFullPanIsActive", variantBool = false, valueStore = valueStoreUser,
		nameLocID = 999116, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Recentralise On Full Pan Is Active",
	},

	-- Recentralise On Rest is Active
	{
		setting = "RecentraliseOnRestIsActive", variantBool = false, valueStore = valueStoreUser,
		nameLocID = 999120, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Recentralise On Rest Is Active",
	},

	-- Left trigger toggle mode
	{
		setting = "LeftTriggerIsToggle", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 999129, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Left Trigger Is Toggle",
	},
	
	-- Cycle Formation Toggle
	{
		setting = "CycleFormationToggle", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 999090, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Cycle Formation Toggle",
    },

	-- Contextual Commands Toggle
	{
		setting = "ContextualCommandToggle", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 999091, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Contextual Command Toggle",
    },

	-- Contextual Military Commands Toggle
	{
		setting = "ContextualMilitaryCommandToggle", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 999092, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Contextual Military Command Toggle",
    },

	-- Contextual Hotkey Icon
	{
		setting = "ContextualHotkeyIcon", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 999823, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Contextual Hotkey Icon",
    },

	-- Snap To Alert  Toggle
	{
		setting = "SnapToAlertToggle", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 999093, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Snap To Alert Toggle",
    },

	-- Action Lines Toggle
	{
		setting = "ActionLinesToggle", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 999100, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = " Action Line Toggle",
    },
	
	-- Reticle Action Line Toggle
	{
		setting = "ReticleActionLineToggle", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 999114, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = " Reticle Action Line Toggle",
    },
	
	-----------------Xbox Accessibility---------------------
	
	-- Xbox UI Text Scale
	{
		xboxOverride = true, setting = "UIScale", 		variantFloat = 1.0,
		nameLocID = 11167121, 	dataTemplate = DT_ComboBox, uiType = UT_List, canPreview = true,
		telemetryName = "Xbox UI Text Scale",
		list = 
		{ 
			-- 100%
			{variantFloat = 1.0, 	locNameID = 11167140}, 
			-- 125%
			{variantFloat = 1.25, 	locNameID = 11167145},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183052"},
		},
	},

	-- Xbox In-Game Chat UI Text Scale
	{
		setting = "InGameChatUIScale", 	variantInt = 0,
		nameLocID = 1001504, 	dataTemplate = DT_ComboBox, uiType = UT_List, canPreview = true,
		telemetryName = "Xbox UI Text Scale",
		list = 
		{ 
			 -- Default
			{variantInt = 0, 	locNameID = 11167140},
			 -- Larger
			{variantInt = 1, 	locNameID = 11167145},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001505"},
		},
	},

	-- Text-To-Speech for Chat Messages
	{
		xboxOverride = true, setting = "TextToSpeechForChatMessagesXbox",  variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11167138, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both, descLocID = 11193667,
		telemetryName = "Text-To-Speech for Chat Messages XBOX",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183057"},
		},
	},

	-- Strong High Contrast
	{
		xboxOverride = true, setting = "StrongHighContrast", variantBool = false, valueStore = valueStoreSystem,
		nameLocID = 999206, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Strong/High Contrast Mode",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$999204"},
		},
	},
	
	-- Subtitle Scale
	{
		xboxOverride = true, setting = "CaptionScale", variantFloat = 1.0,
		nameLocID = 11167123, dataTemplate = DT_ComboBox, uiType = UT_List, canPreview = true,
		telemetryName = "Subtitle Scale",
		list = 
		{
			-- 100%
			{variantFloat = 1.0, 	locNameID = 11167140}, 
			-- 125%
			{variantFloat = 1.25, 	locNameID = 11167145},
			-- 150%
			{variantFloat = 1.5, 	locNameID = 11167146},
		},
		conditions =
		{
			{option = "SubtitleVisibility", operator = "lessthanequal", variantUInt = 1}
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183053"},
		},
	},
	
	-- Show Subtitles
	{
		xboxOverride = true, setting = "ShowHUDSubtitles", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11197432, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "ShowHUDSubtitles",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$999274"},
		},
	},

	-- Subtitle
	{
		xboxOverride = true, setting = "SubtitleVisibility", variantUInt = 2, canPreview = true,
		nameLocID = 11197436, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Subtitles",
		list = 
		{ 
			-- Movie and Game Speech
			{variantUInt = 0, 	locNameID = 11167148}, 
			-- Movie Speech Only
			{variantUInt = 1, 	locNameID = 11167149},
			-- Off 
			{variantUInt = 2, 	locNameID = 2901},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$999195"},
		},
	},
	
	-----------------Xbox Accessibility End---------------------

	-----------------Xbox Controls---------------------
	
	-- Disable Building Rally Point
	{
		setting = "DisableBuildingRallyPoint", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 999829, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Disable Building Rally Point",
		list = 
		{ 
			-- Select
			{variantBool = true, 	locNameID = 999135}, 
			-- Set Rally Point
			{variantBool = false, 	locNameID = 1001235},
		},
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$1001236"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},

		-- Disable Unit Rally Point
	{
		setting = "DisableUnitRallyPoint", variantBool = false, valueStore = valueStoreUser,
		nameLocID = 999432, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Disable Unit Rally Point",
		list = 
		{ 
			-- Select
			{variantBool = true, 	locNameID = 999135}, 
			-- Set Rally Point
			{variantBool = false, 	locNameID = 1001235},
		},
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$1001237"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	
	-- Loose Reticule Speed
	{
		setting = "LooseReticuleSpeed", variantFloat = 50.0, valueStore = valueStoreUser,
		nameLocID = 999113, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 100.0, tickFrequency = 1.0, telemetryName = "Loose Reticule Speed",
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$1001106"},
			{key = "ValueFormat", variantString ="Percentage100"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},

	-- Loose Reticule Area Width
	{
		setting = "LooseReticuleAreaWidth", variantFloat = 50.0, valueStore = valueStoreUser,
		nameLocID = 999107, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 100.0, tickFrequency = 1.0, telemetryName = "Loose Reticule Area Width",
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$1001107"},
			{key = "ValueFormat", variantString ="Percentage100"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	
	-- Loose Reticule Mode
	{
		setting = "LooseReticuleMode", variantUInt = 0, valueStore = valueStoreUser,
		nameLocID = 999103, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Loose Reticule Mode",
		list = 
		{ 
			-- Off
			{variantUInt = 0, 	locNameID = 2901}, 
			-- Circle
			{variantUInt = 1, 	locNameID = 999104},
			-- Rectangle
			{variantUInt = 2, 	locNameID = 1001103},
		},
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$1001105"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	
	-- Controller Button Max Repeat
	-- The longest possible time for a button repeat to register (when higher causes slower scrolling and modification of sliders with RS/LS)
	{
		setting = "ControllerButtonMaxRepeat", variantFloat = 0.1, valueStore = valueStoreUser,
		nameLocID = 999078, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.01, rangeMax = 0.12, tickFrequency = 0.01, telemetryName = "Controller Button Max Repeat",
		persistent = false,
	},
	
	-- Controller Button Min Repeat
	-- The shortest possible time for a button repeat to register (when lower causes faster scrolling and modification of sliders with RS/LS)
	{
		setting = "ControllerButtonMinRepeat", variantFloat = 0.02, valueStore = valueStoreUser,
		nameLocID = 999078, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.01, rangeMax = 0.12, tickFrequency = 0.01, telemetryName = "Controller Button Min Repeat",
		persistent = false,
	},
	
	-- Controller Button Repeat Acceleration Start
	-- Time for a button repeat to register will start to decrease from ControllerButtonMaxRepeat to ControllerButtonMinRepeat after this amount of seconds has passed
	{
		setting = "ControllerButtonRepeatAccelerationStart", variantFloat = 1.0, valueStore = valueStoreUser,
		nameLocID = 999078, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 5.0, tickFrequency = 0.01, telemetryName = "Controller Button Repeat Acceleration Start",
		persistent = false,
	},
	
	-- Controller Button Repeat Acceleration Length
	-- How much time it takes for button repeat time to go from ControllerButtonMaxRepeat to ControllerButtonMinRepeat (should also include ControllerButtonRepeatAccelerationStart)
	{
		setting = "ControllerButtonRepeatAccelerationLength", variantFloat = 4.0, valueStore = valueStoreUser,
		nameLocID = 999078, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 10.0, tickFrequency = 0.01, telemetryName = "Controller Button Repeat Acceleration Length",
		persistent = false,
	},
	
	-- Input Device Type
	{
		setting = "InputDeviceType", variantInt = 0,
		nameLocID = 999201, dataTemplate = DT_ComboBox, uiType = UT_List, canOverrideDefault = true, canChangeInGame = false,
		telemetryName = "Input Device Type",
		list = 
		{ 
			{variantInt = 0, 	locNameID = 999202}, -- Keyboard & Mouse
			{variantInt = 1, 	locNameID = 999203}, -- Xbox Controller
		},
	},
	
	-- Input Device Type
	{
		xboxOverride = true, setting = "InputDeviceType", variantInt = 1,
		nameLocID = 999201, dataTemplate = DT_ComboBox, uiType = UT_List, canOverrideDefault = true, canChangeInGame = false, canPreview = true,
		telemetryName = "Input Device Type",
		list = 
		{ 
			{variantInt = 0, 	locNameID = 999202}, -- Keyboard & Mouse
			{variantInt = 1, 	locNameID = 999203}, -- Xbox Controller
		},		
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001065"},
		},
	},
	
	-- Left Thumbstick Deadzone
	{
		setting = "LeftThumbstickDeadzone",  variantFloat = 0.2, valueStore = valueStoreUser,
		nameLocID = 999101, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.05, rangeMax = 0.95, tickFrequency = 0.01,
		telemetryName = "Left Thumbstick Deadzone",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$999364"},
			{key = "ValueFormat", variantString ="Percentage"}
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},

	-- Right Thumbstick Deadzone
	{
		setting = "RightThumbstickDeadzone",  variantFloat = 0.2, valueStore = valueStoreUser,
		nameLocID = 999102, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.05, rangeMax = 0.95, tickFrequency = 0.01,
		telemetryName = "Right Thumbstick Deadzone",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$999365"},
			{key = "ValueFormat", variantString ="Percentage"}
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	
	-- Radial Hold or Toggle
	{
		setting = "RadialHoldToggle", variantUInt = 1, valueStore = valueStoreUser,
		nameLocID = 999361, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Radial Hold or Toggle",
		list = 
		{ 
			-- Hold
			{variantUInt = 0, 	locNameID = 999345},
			-- Press
			{variantUInt = 1, 	locNameID = 999973},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$999336"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	
	--  Controls
	{
		setting = "Controls", variantUInt = 0,
		nameLocID = 999355, dataTemplate = "XboxControls", uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Controls Preset",
		list = 
		{ 
			-- Default
			{variantUInt = 0, 	locNameID = 999188},
		},
	},
	
	-- Remap Controls (button to open a modal, range value determines return category when modal is closed)
	{	
		setting = "RemapControls", nameLocID = 11168266, dataTemplate = DT_Button, telemetryName = "View and Remap Controls",
		variantFloat = 1.0, uiType = UT_Range, rangeMin = 0.0, rangeMax = 6.0,
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0}
		},
	},
	
	-- Controls Visuals (button to open a modal, range value determines return category when modal is closed)
	{	
		setting = "ControlsVisuals", nameLocID = 1001232, dataTemplate = DT_Button, telemetryName = "Controls Visuals",
		variantFloat = 1.0, uiType = UT_Range, rangeMin = 0.0, rangeMax = 6.0,
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001233"},
		},
	},
	
	-- Scroll wheel zooms camera
	{
		xboxOverride = true, setting = "ScrollWheelZoom", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11149473, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Mouse wheel zoom",
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0},
		},
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$1001248"},
		},
	},
	
	-- Scroll wheel zoom speed (50%..200%)
	{
		xboxOverride = true, setting = "DistanceRateWheelFactor", variantFloat = 1.0,	
		nameLocID = 1001249, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.1, rangeMax = 2.0, tickFrequency = 0.01, telemetryName = "Zoom Speed",
		metaData =
		{
			{key = "ValueFormat", variantString ="Percentage"},
			{key = "TooltipLocKey", variantString = "$1001250"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0},
		},
	},
	
	-- Enable pan acceleration and smoothing
	{
		xboxOverride = true, setting = "EnablePanAccelerationAndSmoothing", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11183427, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Enable Pan Acceleration",
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001243"},
		},
	},
	
	-- Mouse button pan speed (50%..200%)
	{
		xboxOverride = true, setting = "MouseButtonPanSpeedFactor",	variantFloat = 1.0,	
		nameLocID = 11166680, 	dataTemplate = DT_Slider, 	uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.5, rangeMax = 2.0, tickFrequency = 0.01, telemetryName = "Mouse Button Pan Speed",
		metaData =
		{
			{key = "ValueFormat", variantString ="Percentage"},
			{key = "TooltipLocKey", variantString = "$1001244"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0},
		},
	},
	
	-- Edge Pan moves camera when mouse is on game window edge
	{
		xboxOverride = true, setting = "EdgePan", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11149476, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Screen Edge Panning",
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0},
		},
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$1001245"},
		},
	},

		-- Disables Edge Panning while the player is Box Selecting
	{
		xboxOverride = true, setting = "BoxSelectingDisablesEdgePan", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11266946, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Box Selecting Disables Screen Edge Panning",
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0},
		},
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$11266948"},
		},
	},
	
	-- Screen Edge Pan Speed
	{
		xboxOverride = true, setting = "EdgePanSpeedFactor",  variantFloat = 1.0, valueStore = valueStoreUser,
		nameLocID = 11166848, 	dataTemplate = DT_Slider, 	uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.25, rangeMax = 2.0, tickFrequency = 0.01, telemetryName = "Screen Edge Pan Speed",
		metaData =
		{
			{key = "ValueFormat", variantString ="Percentage"},
			{key = "TooltipLocKey", variantString = "$1001246"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0},
		},
	},
	
	-- Keyboard Pan Speed
	{
		xboxOverride = true, setting = "KeyboardPanSpeedFactor",  variantFloat = 1.0, valueStore = valueStoreUser,
		nameLocID = 11166853, 	dataTemplate = DT_Slider, 	uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.25, rangeMax = 2.0, tickFrequency = 0.01, telemetryName = "Keyboard Pan Speed",
		metaData =
		{
			{key = "ValueFormat", variantString ="Percentage"},
			{key = "TooltipLocKey", variantString = "$1001247"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0},
		},
	},
	
	-- Box Select (drag)
	{
		xboxOverride = true, setting = "BandboxSelect", variantKey = "", valueStore = valueStoreUser,
		nameLocID = 1001240, 	dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Box Select (drag)",
		list =
		{
			-- Smart 
			{variantKey = "", locNameID = 11166918},
			-- Villagers Only
			{variantKey = "villager", locNameID = 11166919},
			-- Military Only
			{variantKey = "military", locNameID = 11166920},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001241"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},

	-- Controller Light Bar
	-- Determines whether to animate the light bar depending on haptics
	{
		setting = "ControllerLightBar", variantBool = false, dataTemplate = DT_ToggleCheckBox,
		uiType = UT_Bool, uiAvailability = UA_Both, hardwareAvailability = HA_PS5, valueStore = valueStoreUser,
		telemetryName = "Controller Light Bar", nameLocID = 11269547,
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$11269556"},
		},
	},
	
	-- Controller Rumble On/Off
	{
		setting = "RumbleToggle", variantBool = true, dataTemplate = DT_ToggleCheckBox,
		uiType = UT_Bool, uiAvailability = UA_Both,  valueStore = valueStoreUser,
		telemetryName = "Rumble Toggle", nameLocID = 1001502,
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001501"},
		},
	},
	
	-- Controller Rumble Strength
	{
		setting = "RumbleStrength", variantFloat = 1.0, dataTemplate = DT_Slider, 
		uiType = UT_Range, uiAvailability = UA_Both, valueStore = valueStoreUser,
		rangeMin = 0.0, rangeMax = 1.0, tickFrequency = 0.01,
		telemetryName = "Rumble Strength", nameLocID = 1000653,
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
			{option = "RumbleToggle", operator = "equal", variantBool = true},
		},
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"},
			{key = "TooltipLocKey", variantString = "$1001234"},
		},
	},
	
	-----------------Xbox Controls End---------------------
	
	-----------------Xbox Camera---------------------

	-- Analog Pan Speed
	{
		setting = "AnalogPanSpeed", variantFloat = 5.0, valueStore = valueStoreUser,
		nameLocID = 999106, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 100.0, tickFrequency = 1.0, telemetryName = "Analog Pan Speed",
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage100"},
			{key = "TooltipLocKey", variantString = "$1001242"},
		},
	},

	-- Analog Acceleration
	{
		setting = "AnalogAccelerationSpeed", variantFloat = 0.0, valueStore = valueStoreUser,
		nameLocID = 999079, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 100.0, tickFrequency = 1.0, telemetryName = "Analog Acceleration Speed",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$999215"},
			{key = "ValueFormat", variantString ="Percentage100"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},

	-- Analog Orbit Speed
	{
		setting = "AnalogOrbitSpeed", variantFloat = 50.0, valueStore = valueStoreUser,
		nameLocID = 999132, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 100.0, tickFrequency = 1.0, telemetryName = "Analog Orbit Speed",
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
			{key = "ValueFormat", variantString ="Percentage100"},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001251"},
		},
	},

	-- Analog Zoom Speed
	{
		setting = "AnalogZoomSpeed", variantFloat = 50.0, valueStore = valueStoreUser,
		nameLocID = 999117, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 100.0, tickFrequency = 1.0, telemetryName = "Analog Zoom Speed",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001252"},
			{key = "ValueFormat", variantString ="Percentage100"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},

	-- Camera Zoom and Orbit reset
	{
		setting = "CameraResetAll",  variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 999080, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Reset Both Zoom And Orbit",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$999225"},
		},
	},

	-- Camera Snap Radius
	{
		setting = "CameraSnapRadius", variantFloat = 5.0, valueStore = valueStoreUser,
		nameLocID = 999081, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 100.0, tickFrequency = 1.0, telemetryName = "Camera Snap Radius",
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$1001109"},
			{key = "ValueFormat", variantString ="Percentage100"},
		},
		conditions =
		{
			{option = "CameraSnapIsActive", operator = "equal", variantBool = true},
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},

	-- Camera Snap Is Active
	{
		setting = "CameraSnapIsActive", variantBool = true, valueStore = valueStoreUser, canPreview = true,
		nameLocID = 999436, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "CameraSnapIsActive",
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$1001108"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},

	-- Minimap Reticule Speed
	{
		setting = "MinimapReticuleSpeed", variantFloat = 15.0, valueStore = valueStoreUser,
		nameLocID = 1001211, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 1.0, rangeMax = 20.0, tickFrequency = 0.1, telemetryName = "Minimap Reticule Speed",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001212"},
			{key = "ValueFormat", variantString ="Percentage10"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	
	-- Idle Villager ("worker") Follow/Snap/Select: 0 = Follow, 1 = Select and Center Camera (Default), 2 = Select Only
	{
		xboxOverride = true, deprecated_value = 1, 			valueType = deprecated_valueTypeUInt,
		setting = "IdleVillagerPickType", variantInt = 1,		valueStore = valueStoreUser,
		nameLocID = 11164952, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Idle Villager",
		list =
		{
			-- 0 = Follow
			{variantInt = 0, locNameID = 11166488},
			-- 1 = Select and Center Camera (Default)
			{variantInt = 1, locNameID = 11166489},
			-- 2 = Select Only
			{variantInt = 2, locNameID = 11166490},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001254"},
		},
	},
	
	-- Idle Military Follow/Snap/Select: 0 = Follow, 1 = Select and Center Camera (Default), 2 = Select Only
	{	
		xboxOverride = true, setting = "IdleMilitaryPickType", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 11164953, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Idle Military",
		list =
		{
			-- 0 = Follow
			{variantInt = 0, locNameID = 11166488},
			-- 1 = Select and Center Camera (Default)
			{variantInt = 1, locNameID = 11166489},
			-- 2 = Select Only
			{variantInt = 2, locNameID = 11166490},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001255"},
		},
	},
	
	-- Find and Cycle Units & Buildings Follow/Snap/Select: 0 = Follow, 1 = Select and Center Camera (Default), 2 = Select Only
	{	
		xboxOverride = true, setting = "FindAndCyclePickType", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 11164954, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Find and Cycle Units & Buildings",
		list =
		{
			-- 0 = Follow
			{variantInt = 0, locNameID = 11166488},
			-- 1 = Select and Center Camera (Default)
			{variantInt = 1, locNameID = 11166489},
			-- 2 = Select Only
			{variantInt = 2, locNameID = 11166490},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001256"},
		},
		
	},
	
	-- Cycle through (subselect) selected units Follow/Snap/Select: 0 = Follow, 1 = Select and Center Camera (Default), 2 = Select Only
	{
		xboxOverride = true, setting = "CycleSubselectionPickType", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 11164955, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Cycle through (subselect) selected units",
		list =
		{
			-- 0 = Follow
			{variantInt = 0, locNameID = 11166488},
			-- 1 = Select and Center Camera (Default)
			{variantInt = 1, locNameID = 11166489},
			-- 2 = Select Only
			{variantInt = 2, locNameID = 11166490},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001257"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0},
		},
	},
	   
	-- Custom match cross input
	{
		setting = "CustomMatchCrossInput", variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11261325, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Custom Match Cross Input",
	},
	
	-- Focus on selected unit(s)
	{
		xboxOverride = true, setting = "FocusSelectedFollow", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 11144991, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Focus on selected unit(s)",
		list =
		{
			-- 0 = Follow
			{variantInt = 0, locNameID = 11166488},
			-- 1 = Center Camera (Default)
			{variantInt = 1, locNameID = 11171399},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001258"},
		},
	},

	-- Cycle through control groups Follow/Snap/Select: 0 = Follow, 1 = Select and Center Camera (Default), 2 = Select Only
	{
		setting = "ControlGroupCycleBehaviour", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 11155736, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Control Group Cycling",
		list =
		{
			-- 1 = Select and focus (Default)
			{variantInt = 1, locNameID = 11166489},
			-- 2 Select
			{variantInt = 2, locNameID = 11166490},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11155737"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	
	-----------------Xbox Camera End---------------------
	
	-----------------Xbox Game---------------------
	
	-- Marquee Size Maximum
	{
		setting = "MarqueeSizeMaximum", variantInt = 2, valueStore = valueStoreUser,
		nameLocID = 999123, dataTemplate = DT_ComboBox, uiType = UT_List, canPreview = true,
		telemetryName = "Marquee Size Maximum",
		list = 
		{ 
			{variantInt = 1, 	locNameID = 999125}, 
			{variantInt = 2, 	locNameID = 999126},
			{variantInt = 3, 	locNameID = 999127},
			{variantInt = 4, 	locNameID = 999128},
		},
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$999251"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},

	-- Marquee Hold Time
	{
		setting = "MarqueeHoldTime", variantFloat = 0.35, valueStore = valueStoreUser,
		nameLocID = 999115, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.2, rangeMax = 2.0, tickFrequency = 0.05, telemetryName = "Marquee Hold Time",
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$999363"},
			{key = "ValueFormat", variantString ="Lerp"},
			{key = "LerpMax", variantFloat = 100.0},
			{key = "LerpMin", variantFloat = 0.0},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	
	-- Marquee Speed
	{
		setting = "MarqueeSpeed", variantFloat = 4.0, valueStore = valueStoreUser,
		nameLocID = 999076, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 1.0, rangeMax = 10.0, tickFrequency = 0.1, telemetryName = "Marquee Speed",
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$999252"},
			{key = "ValueFormat", variantString ="Percentage10"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	

	-- Cross-Network
	{
		setting = "CrossNetwork", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 1001538, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "CrossNetwork", canOverrideDefault=true, uiModelTypeOverride="CrossNetworkSystemConfigSettingModel",
		list = 
		{ 
			-- Cross Network Off
			-- On PS5, this matches the player with other PS5 players only
			-- On Xbox, this matches the player with other Xbox One/S/X/Series S/Series X players only
			{variantInt = 0, 	locNameID = 11268996},

			-- Unrestricted cross network matchmaking
			{variantInt = 1, 	locNameID = 11268997},

			-- Matchmaking between consoles only (Xbox and PS5) -- Disabled until automatch update
			-- {variantInt = 2, 	locNameID = 11268998,	hardwareAvailability = HA_Console},
		},
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$11262489"},
		},
	},

	-- Are Labels Active
	{
		setting = "AreLabelsActive", variantBool = true, valueStore = valueStoreSystem,
		nameLocID = 999839, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Are Labels Active",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$999838"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	-- Are Labels Active xbox
	{
		xboxOverride = true, setting = "AreLabelsActive", variantBool = true, valueStore = valueStoreSystem,
		nameLocID = 999839, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool,
		telemetryName = "Are Labels Active",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$999838"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	
	-- Mouse Cursor Speed
	{
		xboxOverride = true, setting = "MouseCursorSpeed", variantFloat = 5.0,	
		nameLocID = 999242, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 10.0, tickFrequency = 1.0,
		telemetryName = "Cursor Speed",
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0}
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$999243"},
		},
	},
	
	-- Dynamic Training
	{
		xboxOverride = true, setting = "DynamicTraining", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11166872, dataTemplate = DT_ToggleCheckBox,
		uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Dynamic Training",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183038"},
		}
	},

	-- Villager Double Press
	{
		setting = "VillagerDoublePress", variantInt = 0,
		nameLocID = 1001200, dataTemplate = DT_ComboBox, uiType = UT_List, canOverrideDefault = true, canChangeInGame = true,
		telemetryName = "Villager Double Press",
		list = 
		{ 
			{variantInt = 0, 	locNameID = 1001201}, -- Select All
			{variantInt = 1, 	locNameID = 1001202}, -- Select Idle
			{variantInt = 2, 	locNameID = 1001203}, -- Selecct By Job
			{variantInt = 3, 	locNameID = 1001204}, -- Disabled
		},
		metaData=
		{
			{key = "TooltipLocKey", variantString = "$1001278"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	-- Villager Double Press xbox
	{
		xboxOverride = true, setting = "VillagerDoublePress", variantInt = 0, valueStore = valueStoreUser,
		nameLocID = 1001200, dataTemplate = DT_ComboBox, uiType = UT_List, canOverrideDefault = true, canChangeInGame = true,
		telemetryName = "Villager Double Press",
		list = 
		{ 
			{variantInt = 0, 	locNameID = 1001201}, -- Select All
			{variantInt = 1, 	locNameID = 1001202}, -- Select Idle
			{variantInt = 2, 	locNameID = 1001203}, -- Selecct By Job
			{variantInt = 3, 	locNameID = 1001204}, -- Disabled
		},
		metaData=
		{
			{key = "TooltipLocKey", variantString = "$1001278"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	
	-- Sticky selection
	{	
		xboxOverride=true, setting = "StickySelection", variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11149472, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Sticky Selection",
		metaData=
		{
			{key = "TooltipLocKey", variantString = "$11182907"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0}
		},
	},

	-- Villager Quick Find Behaviour
	{
		setting = "VillagerQuickFindBehaviour", variantInt = 0,
		nameLocID = 1001329, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Villager Quick Find Behaviour",
		list = 
		{ 
			{variantInt = 0, 	locNameID = 1001327}, -- Idle
			{variantInt = 1, 	locNameID = 1001328}, -- All
		},		
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001238"},
		},
	},
	-- Villager Quick Find Behaviour xbox
	{
		xboxOverride = true, setting = "VillagerQuickFindBehaviour", variantInt = 0, valueStore = valueStoreUser,
		nameLocID = 1001329, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Villager Quick Find Behaviour",
		list = 
		{ 
			{variantInt = 0, 	locNameID = 1001327}, -- Idle
			{variantInt = 1, 	locNameID = 1001328}, -- All
		},		
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001238"},
		},
	},
	-- Military Quick Find Behaviour
	{
		setting = "MilitaryQuickFindBehaviour", variantInt = 1,
		nameLocID = 1001322, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Military Quick Find Behaviour",
		list = 
		{ 
			{variantInt = 0, 	locNameID = 1001327}, -- Idle
			{variantInt = 1, 	locNameID = 1001328}, -- All
		},	
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},		
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001239"},
		},
	},
	-- Military Quick Find Behaviour xbox
	{
		xboxOverride = true, setting = "MilitaryQuickFindBehaviour", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 1001322, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Military Quick Find Behaviour",
		list = 
		{ 
			{variantInt = 0, 	locNameID = 1001327}, -- Idle
			{variantInt = 1, 	locNameID = 1001328}, -- All
		},	
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},		
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001239"},
		},
	},
	-- Reset Training Hints (button to open a modal, range value determines return category when modal is closed)
	{	
		setting = "ResetTraining", nameLocID = 1001259, dataTemplate = DT_Button, telemetryName = "Reset Training Hints",
		variantFloat = 3.0, uiType = UT_Range, rangeMin = 0.0, rangeMax = 6.0,
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001260"},
		},
	},
	
	--Campaign Difficulty
	{
		xboxOverride = true, setting = "CampaignDifficulty", variantInt = 0, valueStore = valueStoreUser,
		nameLocID = 11166952, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Campaign Difficulty",
		list =
		{
			-- Story Mode
			{variantInt = 0, locNameID = 11204435, descLocID = 11204436, telemetryName = "Story"},
			-- Easy
			{variantInt = 1, locNameID = 11166953, descLocID = 11201419, telemetryName = "Easy"},
			-- Intermediate
			{variantInt = 2, locNameID = 11166954, descLocID = 11201427, telemetryName = "Intermediate"},
			-- Hard
			{variantInt = 3, locNameID = 11166955, descLocID = 11201428, telemetryName = "Hard"},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001261"},
		},
	},

	-- Quick Find Behaviour Preset
	{
		setting = "QuickFindBehaviourPreset", variantInt = 0,
		nameLocID = 1001309, dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "QuickFindBehaviourPreset",
		list = 
		{ 
			{variantInt = 0, 	locNameID = 1001305},
			{variantInt = 1, 	locNameID = 1001306},
			{variantInt = 2, 	locNameID = 1001307},
			{variantInt = 3, 	locNameID = 1001308},
		},		
	},
	
	-- Campaign Auto-Save
	{
		xboxOverride = true, setting = "CampaignAutoSave",  variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11166956, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Campaign Auto-Save",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001262"},
		},
	},

		-- Queued Command Priority
	{
		xboxOverride = true, setting = "QueuedCommandPriority", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 11254106, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Queued Command Priority",
		list =
		{
			{variantInt = 0, locNameID = 11254107, telemetryName = "Gathering"},
			{variantInt = 1, locNameID = 11254108, telemetryName = "Construction"},			
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11254109"},
		},
	},
	
	-----------------Xbox Game End---------------------
	
	-----------------Xbox Visuals---------------------
	
	-- Construction Progress Bars
	{
		xboxOverride = true, setting = "ConstructionProgressVisibilityMode", variantInt = 1, valueStore = valueStoreUser,
		nameLocID = 11167004, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Construction Progress Bars",
		list =
		{
			-- Always On
			{variantInt = 2, locNameID = 11167001},
			-- Selection Only,
			{variantInt = 1, locNameID = 11167003},
			-- Always Off
			{variantInt = 3, locNameID = 11167002},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$999259"},
		},
	},
	
	-- Show Game Duration Timer
	{
		xboxOverride = true, setting = "ShowGameTimer", variantBool = false, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11166633, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Show Game Duration Timer",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$999260"},
		},
	},
	
	-- Adjust Brightness (button to open a modal, range value determines return category when modal is closed)
	{	
		setting = "AdjustBrightness", nameLocID = 999708, dataTemplate = DT_Button, telemetryName = "Adjust Brightness",
		variantFloat = 4.0, uiType = UT_Range, rangeMin = 0.0, rangeMax = 6.0,
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001263"},
		},
	},
	
	-- Player colour
	{	
		xboxOverride = true, setting = "PlayerColour", variantBool = true, valueStore = valueStoreUser, 
		nameLocID = 11159452, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Player Colors",
		list =
		{
			-- Unique 
			{variantBool = true, locNameID = 11166881},
			-- Team-Based 
			{variantBool = false, locNameID = 11166882},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001264"},
		},
	},
	
	-- Show Player Scores in HUD
	{
		xboxOverride = true, setting = "ShowPlayerScores", variantBool = false, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11217778, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Show Player Scores in HUD",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001286"},
		},
		conditions =
		{
			{option = "ShowPlayerInfo", operator = "equal", variantBool = true},
		},
	},
	
	-- Show Player Info in HUD
	{
		setting = "ShowPlayerInfo", variantBool = false, valueStore = valueStoreUser, canPreview = true,
		nameLocID = 11166968, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Show Player Info in HUD",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001266"},
		},
	},
	
	-- Show waypoint markers for single actions
	{
		xboxOverride = true, setting = "SingleActionWaypointMarkers", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 11230613, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Single Action Waypoint Markers",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001265"},
		},
	},
	
	-- Minimap Zoom Level
	{
		xboxOverride = true, setting = "MinimapZoomLevel", variantFloat = 1.0, valueStore = valueStoreUser,
		nameLocID = 11245268, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Minimap Zoom Level",
		list =
		{
			{variantFloat = 1.0, locNameID = 11245269, telemetryName = "Normal Size"},
			{variantFloat = 1.25, locNameID = 11245270, telemetryName = "125% Zoom"},
			{variantFloat = 1.5, locNameID = 11245271, telemetryName = "150% Zoom"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001267"},
		},
	},
	
	-- Control Group Shortcuts
	{
		xboxOverride = true, setting = "ShowControlGroup", variantBool = true, valueStore = valueStoreUser, canPreview = false,
		nameLocID = 11167007, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Control Group Shortcuts",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11183040"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 0},
		},
	},

	-- Radials and select all on screen keybind display toggle
	{
		setting = "ShowHUDKeybindWidgets", variantBool = true, valueStore = valueStoreUser,
		nameLocID =1001520, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Show Keybind Widgets in HUD",
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$1001521"},
		},
				conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},

	-- LT and RT display toggle 
	{
		setting = "ShowHUDCommandWidgets", variantBool = true, valueStore = valueStoreUser,
		nameLocID =1001522, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Show Command Widgets in HUD",
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$1001523"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},

	-- Quick Find dpad info display toggle
	{
		setting = "ShowQuickFindWidgets", variantBool = true, valueStore = valueStoreUser,
		nameLocID =1001524, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Show Dpad QuickFind Widgets in HUD",
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$1001525"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},

	-- Show VPS Warning Messages
	{
		setting = "ShowVPSWarningMessages", variantBool = true, valueStore = valueStoreUser,
		nameLocID =11259807, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Show VPS Warning Messages",
		metaData =
		{
			{key = "TooltipLocKey", variantString = "$11259808"},
		},
		conditions =
		{
			{option = "InputDeviceType", operator = "equal", variantInt = 1},
		},
	},
	
	-----------------Xbox Visuals End---------------------
	
	-----------------Xbox Audio---------------------
	
	-- Voice Chat Volume (0..100)
	{	
		setting = "VoiceChatVolume", variantFloat = 1.0, canPreview = true, valueStore = valueStoreUser,
		nameLocID = 999261, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Voice Chat Volume",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"}
		},
		conditions =
		{
			{option = "UseVoiceChat", operator = "equal", variantBool = true}
		},
	},
	
	-- Voice Chat Volume (0..100)
	{	
		xboxOverride = true, setting = "VoiceChatVolume", variantFloat = 1.0, canPreview = true, valueStore = valueStoreUser,
		nameLocID = 999261, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Voice Chat Volume",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"},
			{key = "TooltipLocKey", variantString = "$1001273"},
		},
		conditions =
		{
			{option = "UseVoiceChat", operator = "equal", variantBool = true}
		},
	},
	
	-- Audio Output
	{
		setting = "AudioOutput", variantUInt = 1, canOverrideDefault = true,
		nameLocID = 999264, dataTemplate = DT_ComboBox, uiType = UT_List, uiAvailability = UA_Both,
		telemetryName = "Audio Output",
		list =
		{
			-- Mono
			{variantUInt = 0, locNameID = 999265},
			-- Stereo
			{variantUInt = 1, locNameID = 999266},
			-- 5.1
			{variantUInt = 2, locNameID = 999268},
			-- 7.1
			{variantUInt = 3, locNameID = 999267},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001279"},
		},
	},
	
	-- Master volume (0..100)
	{	
		xboxOverride = true, setting = "masterVolume", variantFloat = 1.0, canPreview = true, valueStore = valueStoreUser,
		nameLocID = 701002, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Master Volume",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"},
			{key = "TooltipLocKey", variantString = "$1001268"},
		},
	},
	
	-- Music volume (0..100)
	{	
		xboxOverride = true, setting = "musicVolume", variantFloat = 1.0, canPreview = true, valueStore = valueStoreUser,
		nameLocID = 701004, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Music Volume",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"},
			{key = "TooltipLocKey", variantString = "$1001269"},
		},
	},
	
	-- SFX volume (0..100)
	{	
		xboxOverride = true, setting = "sfxVolume", variantFloat = 1.0, canPreview = true, valueStore = valueStoreUser,
		nameLocID = 11149485, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Sound Effects Volume",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"},
			{key = "TooltipLocKey", variantString = "$1001271"},
		},
	},
	
	-- Speech volume (0..100)
	{
		xboxOverride = true, setting = "speechVolume", variantFloat = 1.0, canPreview = true, valueStore = valueStoreUser,
		nameLocID = 701003, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Speech Volume",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"},
			{key = "TooltipLocKey", variantString = "$1001270"},
		},
	},
	
	-- Taunts volume (0..100)
	{
		xboxOverride = true, setting = "tauntsVolume", variantFloat = 1.0, canPreview = true, valueStore = valueStoreUser,
		nameLocID = 11231315, dataTemplate = DT_Slider, uiType = UT_Range, uiAvailability = UA_Both,
		rangeMin = 0.0, rangeMax = 1.0, tickFrequency = 0.01, telemetryName = "Speech Volume",
		metaData = 
		{
			{key = "ValueFormat", variantString ="Percentage"},
			{key = "TooltipLocKey", variantString = "$1001272"},
		},
	},
	
	-- (Audio) Dynamic range (Wide (Default), Boost, Midnight Mode)
	{
		xboxOverride = true, setting = "AudioDynamicRange", variantUInt = 0, canOverrideDefault = true,
		nameLocID = 11167092, dataTemplate = DT_ComboBox, uiType = UT_List, valueStore = valueStoreUser,
		telemetryName = "Audio Dynamic Range",
		list =
		{
			-- Wide Mode
			{variantUInt = 0, locNameID = 11167091},
			-- Boost
			{variantUInt = 1, locNameID = 11167090},
			-- Midnight Mode
			{variantUInt = 2, locNameID = 11167089},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001274"},
		},
	},
	
	-----------------Xbox Audio End---------------------
	
	-----------------Xbox Social---------------------
	
	-- Mute Microphone
	{	
		xboxOverride = true, setting = "MuteMicrophone",  variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11248594, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = false, telemetryName = "Mute Microphone",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001275"},
		},
	},
	
	-- Allow Messages
	-- See ChatManager.cpp for implementation
	{
		xboxOverride = true, setting = "AllowMessages", variantUInt = 0, valueStore = valueStoreUser, uiAvailability = UA_Both,
		nameLocID = 11167098, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Allow Messages",
		list = 
		{ 
			-- From Everyone
			{variantUInt = 0, locNameID = 11167103}, 
			-- From Friends
			{variantUInt = 1, locNameID = 11167104},
			-- From Nobody
			{variantUInt = 2, locNameID = 11167105},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001276"},
		},
	},
	
	-- Allow Friend Requests
	-- See RelationshipManager.cpp for implementation
	{
		xboxOverride = true, setting = "AllowFriendRequests", variantUInt = 0, valueStore = valueStoreUser, uiAvailability = UA_Both,
		nameLocID = 11167099, 	dataTemplate = DT_ComboBox, uiType = UT_List,
		telemetryName = "Allow Friend Requests",
		list = 
		{ 
			-- From Everyone
			{variantUInt = 0, locNameID = 11167103}, 
			-- From System Friends
			{variantUInt = 1, locNameID = 11167106},
			-- From Nobody
			{variantUInt = 2, locNameID = 11167105},
		},
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001277"},
		},
	},
	
	-----------------Xbox Social End---------------------
	
	-----------------Audio---------------------

	-- Mute Microphone
	{	
		setting = "MuteMicrophone", xboxOverride = true, variantBool = false, valueStore = valueStoreUser,
		nameLocID = 11248594, 	dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		isDebug = false, telemetryName = "Mute Microphone",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$1001275"},
		},
	},

	-----------------Social---------------------
	
	-- OnlinePresence
	{
		xboxOverride = true, setting = "OnlinePresence", variantBool = true, valueStore = valueStoreUser,
		nameLocID = 999269, dataTemplate = DT_ToggleCheckBox, uiType = UT_Bool, uiAvailability = UA_Both,
		telemetryName = "Online Presence",
		metaData = 
		{
			{key = "TooltipLocKey", variantString = "$11204585"},
		},
	},
}

--	Launch game with -forcesettingsgroup <name> to force a group of settings listed below
-- Tools should force "tools" in-code
settings_groups =
{
	tools =
	{
		{	setting="VerticalSync",			variantBool = false },
		{	setting="FrameRateLimit",		variantUInt = 0 },
		{	setting="Physics",				variantUInt = 3 },
		
		-- options from GraphicsOptions::k_graphicsQualityOptions
		{	setting="GraphicsQuality",		variantUInt = 2 },
		{	setting="ModelDetail", 			variantUInt = 2 },
		
		{	setting="AntiAliasing",			variantFloat = 0.5 },
		{	setting="TextureDetail", 		variantUInt = 0 },
		{	setting="WorldViewQuality", 	variantUInt = 2 },
		{	setting="AudioOutputQuality", 	variantUInt = 1 },
		{   setting="SkeletalAnimationLod", variantUInt = 0 },
	},
	minspec_buildmachine =
	{
		-- options unique to minspec_buildmachine:
		-- For profiling, we turn off VerticalSync and FrameRateLimit
		{	setting="VerticalSync",			variantBool = false },
		{	setting="FrameRateLimit",		variantUInt = 0 },
		-- HDR should be off for profiling, so the results will
		-- not be dependent on connected monitor
		{	setting = "HDR",                variantBool = false },
		
		-- options matching autoconfig_gen8 values:
		{	setting = "Gen7",                  variantBool = false },
		{	setting = "AnimationQuality",      variantUInt = 1 },
		{	setting = "AntiAliasing",          variantFloat = 0.5 },
		{	setting = "AudioOutputQuality",    variantUInt = 1 },
		{	setting = "GraphicsQuality",       variantUInt = 1 },
		{	setting = "MoviePlayerPixelCount", variantInt = 8294400 },
		{	setting = "ModelDetail",           variantUInt = 1 },
		{	setting = "Physics",               variantUInt = 1 },
		{	setting = "TextureDetail",         variantUInt = 2 },
		{	setting = "VolumetricLighting",    variantUInt = 1 },
		{	setting = "AmbientOcclusion",      variantUInt = 2 },
	},
	maxspec_buildmachine =
	{
		{	setting="VerticalSync",			variantBool = false },
		{	setting="FrameRateLimit",		variantUInt = 0 },
		{	setting="Physics",				variantUInt = 3 },
		
		-- options from GraphicsOptions::k_graphicsQualityOptions
		{	setting="GraphicsQuality",		variantUInt = 2 },
		{	setting="ModelDetail", 			variantUInt = 2 },
		
		{	setting="AntiAliasing",			variantFloat = 1 },
		{	setting="TextureDetail", 		variantUInt = 0 },
		{	setting="WorldViewQuality", 	variantUInt = 2 },
		{	setting="AudioOutputQuality", 	variantUInt = 0 },
		{   setting="SkeletalAnimationLod", variantUInt = 0 },
	},
	capture =
	{
		{	setting="VerticalSync",			variantBool = false },
		{	setting="FrameRateLimit",		variantUInt = 0 },
		{	setting="Physics",				variantUInt = 3 },
		
		-- options from GraphicsOptions::k_graphicsQualityOptions
		{	setting="GraphicsQuality",		variantUInt = 2 },
		{	setting="ModelDetail", 			variantUInt = 4 },
		
		{	setting="AntiAliasing",			variantFloat = 1 },
		{	setting="TextureDetail", 		variantUInt = 0 },
		{	setting="WorldViewQuality", 	variantUInt = 2 },
		{	setting="AudioOutputQuality", 	variantUInt = 0 },
		{   setting="SkeletalAnimationLod", variantUInt = 0 },

		-- Capture Tool specific settings
		{	setting="FXForceSpawnOffscreen", 			variantBool = true},
		{	setting="UseOnlySingleCascadingShadows", 	variantBool = true},
		{	setting="TerrainLod", 						variantInt = 0},
		{	setting="ShadowMapToggleDistanceOverride", 	variantUInt = 1},
		{	setting="ShadowMapSetDistanceOverride", 	variantUInt = 1},
		{	setting="shadowSize", 						variantInt = 16384},
	},

	-- For what settings should be applied at each gen,
	-- http://relicwiki/display/CRDUXUI/Other+UX-UI+-+Settings+Tracker
	-- When on gen 7 assets + pipeline, always use these settings.
	autoconfig_gen7 =
	{
		-- Baseline
		{ setting = "Gen7",                  variantBool = true },
		{ setting = "VerticalSync",          variantBool = false },

		-- CPU Medium		
		-- AnimationQuality==3, means VERY_LOW, it controls the ideal load for the animation system
		{ setting = "AnimationQuality",      variantUInt = 3 },
		{ setting = "MoviePlayerPixelCount", variantInt = 2073600 },
		{ setting = "Physics",               variantUInt = 0 },

		-- RAM Low

		-- GPU Gen 7
		{ setting = "AntiAliasing",          variantFloat = 0 },
		{ setting = "Autoconfig_GameplayScaleTargetResolution", variantString = "1280:720:0:0" },
		{ setting = "GraphicsQuality",       variantUInt = 0 },
		{ setting = "VolumetricLighting",    variantUInt = 3 },
		{ setting = "AmbientOcclusion",      variantUInt = 0 },

		-- GPU VRAM Low
		{ setting = "ModelDetail",           variantUInt = 0 },
		{ setting = "TextureDetail",         variantUInt = 2 },

		{ setting = "TextureStreamingEnabled", 			variantBool = true },
		{ setting = "TextureStreamingMinMipCount", 		variantUInt = 6 },			
		{ setting = "TextureStreamingMaxMipCount", 		variantUInt = 11 }, 		
		{ setting = "TextureStreamingMaxMemoryUsage", 		variantUInt = 128 },
		{ setting = "TextureStreamingMaxConcurrentStreams",	variantUInt = 32 },
		{ setting = "TextureStreamingCoverageBias", 		variantFloat = 2.0 },

		-- Special: Unlimited framerate
		{ setting = "FrameRateLimit",        variantUInt = 0 },

		-- Special: Audio quality high (relies on cpu/ram)
		{ setting = "AudioOutputQuality",    variantUInt = 2 },
		
		-- Special: [RC3] Always use 720p exclusive fullscreen
		{ setting = "resolution",            variantString = "1280:720:0:0" },
		{ setting = "windowmode",            variantUInt = 1 },
	},
	
	-- Settings for Gen 8 from http://relicwiki/pages/viewpage.action?spaceKey=CRDUXUI&title=Other+UX-UI+-+Settings+Tracker
	-- This group is not used by settings autodetect. For gen 8 and gen 9 systems, settings autodetect will use autoconfig_baseline and one each from autodetect_cpu_*, autodetect_ram_*, autodetect_gpu_*, and autodetect_vram_*. See http://relicwiki/display/CARD/Graphics+Setting+Autodetection for how this works. This settings group is here as a reference to what settings should be set on a gen 8 spec machine.
	autoconfig_gen8 =
	{
		-- Baseline
		{ setting = "Gen7",                  variantBool = false },
		{ setting = "VerticalSync",          variantBool = true },

		-- CPU Medium
		{ setting = "AnimationQuality",      variantUInt = 1 },
		{ setting = "MoviePlayerPixelCount", variantInt = 8294400 },
		{ setting = "Physics",               variantUInt = 1 },

		-- RAM Low

		-- GPU Gen 8 1080p
		{ setting = "AntiAliasing",          variantFloat = 0.5 },
		{ setting = "Autoconfig_GameplayScaleTargetResolution", variantString = "1920:1080:0:0" },
		{ setting = "GraphicsQuality",       variantUInt = 1 },
		{ setting = "VolumetricLighting",    variantUInt = 1 },
		{ setting = "AmbientOcclusion",      variantUInt = 2 },

		-- GPU VRAM Med
		{ setting = "ModelDetail",           variantUInt = 1 },
		{ setting = "TextureDetail",         variantUInt = 2 },
		{ setting = "TextureStreamingEnabled", 				variantBool = true },
		{ setting = "TextureStreamingMinMipCount", 			variantUInt = 9 },
		{ setting = "TextureStreamingMaxMipCount", 			variantUInt = 13 },
		{ setting = "TextureStreamingMaxMemoryUsage", 		variantUInt = 512 },
		{ setting = "TextureStreamingMaxConcurrentStreams", variantUInt = 32 },
		{ setting = "TextureStreamingCoverageBias", 		variantFloat = 2.0 },

		-- Special: Unlimited framerate
		{ setting = "FrameRateLimit",        variantUInt = 0 },

		-- Special: Audio quality high (relies on cpu/ram)
		{ setting = "AudioOutputQuality",    variantUInt = 2 },
	},

	-- Settings for Gen 9 from http://relicwiki/pages/viewpage.action?spaceKey=CRDUXUI&title=Other+UX-UI+-+Settings+Tracker
	-- This group is not used by settings autodetect. For gen 8 and gen 9 systems, settings autodetect will use autoconfig_baseline and one each from autodetect_cpu_*, autodetect_ram_*, autodetect_gpu_*, and autodetect_vram_*. See http://relicwiki/display/CARD/Graphics+Setting+Autodetection for how this works. This settings group is here as a reference to what settings should be set on a gen 9 spec machine.
	autoconfig_gen9 =
	{
		-- Baseline
		{ setting = "Gen7",                  variantBool = false },
		{ setting = "VerticalSync",          variantBool = true },

		-- CPU High
		{ setting = "AnimationQuality",      variantUInt = 2 },
		{ setting = "MoviePlayerPixelCount", variantInt = 8294400 },
		{ setting = "Physics",               variantUInt = 2 },

		-- RAM High

		-- GPU Gen 9 4k
		{ setting = "AntiAliasing",          variantFloat = 1.0 },
		{ setting = "GameplayScale",         variantFloat = 1.0 },
		{ setting = "GraphicsQuality",       variantUInt = 2 },
		{ setting = "VolumetricLighting",    variantUInt = 2 },
		{ setting = "AmbientOcclusion",      variantUInt = 2 },

		-- GPU VRAM High
		{ setting = "ModelDetail",           variantUInt = 2 },
		{ setting = "TextureDetail",         variantUInt = 0 },
		{ setting = "TextureStreamingEnabled", 	variantBool = false },

		-- Special: Unlimited framerate
		{ setting = "FrameRateLimit",        variantUInt = 0 },

		-- Special: Audio quality high (relies on cpu/ram)
		{ setting = "AudioOutputQuality",    variantUInt = 0 },
	},

	-- When on normal assets, pick "autoconfig_baseline" plus one from each category: CPU, RAM, GPU, VRAM
	autoconfig_baseline =
	{
		{ setting = "Gen7",                  variantBool = false },
		{ setting = "VerticalSync",          variantBool = true },
	},

	autoconfig_cpu_low =
	{
		{ setting = "AnimationQuality",      variantUInt = 0 },
		{ setting = "MoviePlayerPixelCount", variantInt = 2073600 },
		{ setting = "Physics",               variantUInt = 1 },
	},
	autoconfig_cpu_medium =
	{
		{ setting = "AnimationQuality",      variantUInt = 1 },
		{ setting = "MoviePlayerPixelCount", variantInt = 8294400 },
		{ setting = "Physics",               variantUInt = 1 },
	},
	autoconfig_cpu_high =
	{
		{ setting = "AnimationQuality",      variantUInt = 2 },
		{ setting = "MoviePlayerPixelCount", variantInt = 8294400 },
		{ setting = "Physics",               variantUInt = 2 },
	},

	-- Empty settings groups used by autodetect. Do not remove.
	autoconfig_ram_low = -- Target 8GB
	{
	},
	autoconfig_ram_medium = -- Target 10GB
	{
	},
	autoconfig_ram_high = -- Target 12GB
	{
	},

	autoconfig_gpu_gen8_720p =
	{
		{ setting = "AntiAliasing",          variantFloat = 0 },
		-- { setting = "GameplayScale",         variantFloat = 1.0 }, -- Targeting specific resolution
		{ setting = "GraphicsQuality",       variantUInt = 1 },
		{ setting = "VolumetricLighting",    variantUInt = 0 },
		{ setting = "AmbientOcclusion",      variantUInt = 1 },

		{ setting = "Autoconfig_GameplayScaleTargetResolution", variantString = "1280:720:0:0" },

		{ setting = "DynamicResolutionScaleMin",					variantFloat = 0.7 },
		{ setting = "DynamicResolutionFramesBeforeDownsample",		variantUInt = 15 },
		{ setting = "DynamicResolutionFramesBeforeUpsample",		variantUInt = 25 },
		{ setting = "DynamicResolutionDesiredFrameTime",			variantFloat = 32.0 },
		{ setting = "DynamicResolutionAllowedFrameTimeVariance",	variantFloat = 1.5 },
		{ setting = "DynamicResolutionAdjustmentFactor",			variantFloat = 1.0 },
	},
	autoconfig_gpu_gen8_1080p =
	{
		{ setting = "AntiAliasing",          variantFloat = 0.5 },
		-- { setting = "GameplayScale",         variantFloat = 1.0 }, -- Targeting specific resolution
		{ setting = "GraphicsQuality",       variantUInt = 1 },
		{ setting = "VolumetricLighting",    variantUInt = 1 },
		{ setting = "AmbientOcclusion",      variantUInt = 2 },

		{ setting = "Autoconfig_GameplayScaleTargetResolution", variantString = "1920:1080:0:0" },

		{ setting = "DynamicResolutionScaleMin",					variantFloat = 0.6 },
		{ setting = "DynamicResolutionFramesBeforeDownsample",		variantUInt = 15 },
		{ setting = "DynamicResolutionFramesBeforeUpsample",		variantUInt = 25 },
		{ setting = "DynamicResolutionDesiredFrameTime",			variantFloat = 32.0 },
		{ setting = "DynamicResolutionAllowedFrameTimeVariance",	variantFloat = 1.5 },
		{ setting = "DynamicResolutionAdjustmentFactor",			variantFloat = 1.0 },
	},
	autoconfig_gpu_gen9_1080p =
	{
		{ setting = "AntiAliasing",          variantFloat = 0.5 },
		-- { setting = "GameplayScale",         variantFloat = 1.0 }, -- Targeting specific resolution
		{ setting = "GraphicsQuality",       variantUInt = 2 },
		{ setting = "VolumetricLighting",    variantUInt = 2 },
		{ setting = "AmbientOcclusion",      variantUInt = 2 },

		{ setting = "Autoconfig_GameplayScaleTargetResolution", variantString = "1920:1080:0:0" },

		{ setting = "DynamicResolutionScaleMin",					variantFloat = 0.6 },
		{ setting = "DynamicResolutionFramesBeforeDownsample",		variantUInt = 15 },
		{ setting = "DynamicResolutionFramesBeforeUpsample",		variantUInt = 25 },
		{ setting = "DynamicResolutionDesiredFrameTime",			variantFloat = 32.0 },
		{ setting = "DynamicResolutionAllowedFrameTimeVariance",	variantFloat = 1.5 },
		{ setting = "DynamicResolutionAdjustmentFactor",			variantFloat = 1.0 },
	},
	autoconfig_gpu_gen9_2160p =
	{
		{ setting = "AntiAliasing",          variantFloat = 1.0 },
		{ setting = "GameplayScale",         variantFloat = 1.0 },
		{ setting = "GraphicsQuality",       variantUInt = 2 },
		{ setting = "VolumetricLighting",    variantUInt = 2 },
		{ setting = "AmbientOcclusion",      variantUInt = 3 },

		 -- { setting = "Autoconfig_GameplayScaleTargetResolution", variantString = "3840:2160:0:0" }, -- Always 100%
		{ setting = "DynamicResolutionScaleMin",					variantFloat = 0.5 },
		{ setting = "DynamicResolutionFramesBeforeDownsample",		variantUInt = 15 },
		{ setting = "DynamicResolutionFramesBeforeUpsample",		variantUInt = 25 },
		{ setting = "DynamicResolutionDesiredFrameTime",			variantFloat = 32.0 },
		{ setting = "DynamicResolutionAllowedFrameTimeVariance",	variantFloat = 1.5 },
		{ setting = "DynamicResolutionAdjustmentFactor",			variantFloat = 1.0 },
	},

	autoconfig_gpu_vram_low = -- Target 2GB
	{
		{ setting = "ModelDetail", variantUInt = 1 },
		{ setting = "TextureDetail", variantUInt = 2 },
		{ setting = "TextureStreamingEnabled", 				variantBool = true },
		{ setting = "TextureStreamingMinMipCount", 			variantUInt = 6 },			
		{ setting = "TextureStreamingMaxMipCount", 			variantUInt = 11 }, 		
		{ setting = "TextureStreamingMaxMemoryUsage", 		variantUInt = 256 },
		{ setting = "TextureStreamingMaxConcurrentStreams", variantUInt = 32 },
		{ setting = "TextureStreamingCoverageBias", 		variantFloat = 2.0 },
	},
	autoconfig_gpu_vram_medium = -- Target 4GB
	{
		{ setting = "ModelDetail", variantUInt = 1 },
		{ setting = "TextureDetail", variantUInt = 1 },
		{ setting = "TextureStreamingEnabled", 				variantBool = true },
		{ setting = "TextureStreamingMinMipCount", 			variantUInt = 9 },
		{ setting = "TextureStreamingMaxMipCount", 			variantUInt = 13 },
		{ setting = "TextureStreamingMaxMemoryUsage", 		variantUInt = 1024 },
		{ setting = "TextureStreamingMaxConcurrentStreams", variantUInt = 32 },
		{ setting = "TextureStreamingCoverageBias", 		variantFloat = 2.0 },
	},
	autoconfig_gpu_vram_high = -- Target 6GB
	{
		{ setting = "ModelDetail", variantUInt = 2 },
		{ setting = "TextureDetail", variantUInt = 0 },
		{ setting = "TextureStreamingEnabled", variantBool = false },
	},

	-- Special cases for some settings
	autoconfig_audio_low =
	{
		{ setting = "AudioOutputQuality",    variantUInt = 2 },
	},
	autoconfig_audio_medium =
	{
		{ setting = "AudioOutputQuality",    variantUInt = 1 },
	},
	autoconfig_audio_high =
	{
		{ setting = "AudioOutputQuality",    variantUInt = 0 },
	},

	-- Configuration for console platforms.
	autoconfig_xbox_series_x = -- Applied if we are running on an xbox series x
	{
		-- Output Resolution: 4k
		-- Target: 4k 60fps

		{ setting = "Gen7",                  	variantBool = false },
		{ setting = "AnimationQuality",      	variantUInt = 1 },
		{ setting = "AntiAliasing",          	variantFloat = 0.5 },
		{ setting = "AudioOutputQuality",    	variantUInt = 5 },
		{ setting = "GameplayScale",         	variantFloat = 1.0 },
		{ setting = "GraphicsQuality",       	variantUInt = 2 },
		{ setting = "HDR",                   	variantBool = true },
		{ setting = "MoviePlayerPixelCount", 	variantInt = 8294400 },
		{ setting = "ModelDetail",           	variantUInt = 2 },
		{ setting = "Physics",               	variantUInt = 2 },
		{ setting = "TextureDetail",         	variantUInt = 1 },
		{ setting = "VariableRateShading",   	variantBool = false }, -- disabled VRS in favor of upcoming dynamic resolution

		{ setting = "TextureStreamingEnabled", 					variantBool = true },
		{ setting = "TextureStreamingMinMipCount", 				variantUInt = 9 },			-- 256
		{ setting = "TextureStreamingMaxMipCount", 				variantUInt = 13 }, 		-- 8096x8096
		{ setting = "TextureStreamingMaxMemoryUsage", 			variantUInt = 1024 },
		{ setting = "TextureStreamingMaxCriticalCachedMemory", 	variantUInt = 80 },
		{ setting = "TextureStreamingMaxConcurrentStreams", 	variantUInt = 32 },
		{ setting = "TextureStreamingCoverageBias", 			variantFloat = 2.0 },

		-- We use a lower shadow mode, but override the shadow
		-- map size to be larger and reduce aliasing.
		{ setting = "VolumetricLighting",    	variantUInt = 1 },
		{ setting = "UseOnlyLowShadowDrawStyle",variantBool = true },
		{ setting = "NearShadowMapSizeOverride",variantUInt = 2048 },
		{ setting = "FarShadowMapSizeOverride",	variantUInt = 1024 },
		
		{ setting = "VerticalSync",          	variantBool = true },
		{ setting = "DynamicVerticalSync",   	variantBool = false },
		{ setting = "FrameRateLimit", 		 	variantUInt = 0 },

		-- empty string = do not override "GameplayScale" default set above
		{ setting = "Autoconfig_GameplayScaleTargetResolution", variantString = "" },
		{ setting = "resolution",            					variantString = "3840:2160:1:60" },

		-- Gameplay settings specific to this platform
		{ setting = "InputDeviceType",    		variantInt = 1 },

		{ setting = "AmbientOcclusion",      variantUInt = 2 },

		{ setting = "DynamicResolutionScaleMin",					variantFloat = 0.85 },
		{ setting = "DynamicResolutionFramesBeforeDownsample",		variantUInt = 15 },
		{ setting = "DynamicResolutionFramesBeforeUpsample",		variantUInt = 25 },
		{ setting = "DynamicResolutionDesiredFrameTime",			variantFloat = 16.0 },
		{ setting = "DynamicResolutionAllowedFrameTimeVariance",	variantFloat = 0.6 },
		{ setting = "DynamicResolutionAdjustmentFactor",			variantFloat = 1.0 },
	},
	autoconfig_xbox_series_s = -- Applied if we are running on an xbox series s
	{
		-- Output Resolution: 1080p
		-- Target: 1080p 60fps --

		{ setting = "Gen7",                  	variantBool = false },
		{ setting = "AnimationQuality",      	variantUInt = 1 },
		{ setting = "AntiAliasing",          	variantFloat = 0.5 },
		{ setting = "AudioOutputQuality",    	variantUInt = 6 },
		{ setting = "GameplayScale",         	variantFloat = 1.0 },
		{ setting = "GraphicsQuality",       	variantUInt = 2 },
		{ setting = "HDR",                   	variantBool = true },
		{ setting = "MoviePlayerPixelCount", 	variantInt = 2073600 },
		{ setting = "ModelDetail",           	variantUInt = 2 },
		{ setting = "Physics",               	variantUInt = 2 },
		{ setting = "TextureDetail",         	variantUInt = 2 },
		{ setting = "VariableRateShading",   	variantBool = false }, -- disabled VRS in favor of upcoming dynamic resolution
		
		{ setting = "TextureStreamingEnabled", 					variantBool = true },
		{ setting = "TextureStreamingMinMipCount", 				variantUInt = 8 },			-- 128
		{ setting = "TextureStreamingMaxMipCount", 				variantUInt = 12 }, 		-- 2048x2048
		{ setting = "TextureStreamingMaxMemoryUsage", 			variantUInt = 512 },
		{ setting = "TextureStreamingMaxCriticalCachedMemory", 	variantUInt = 64 },
		{ setting = "TextureStreamingMaxConcurrentStreams", 	variantUInt = 32 },
		{ setting = "TextureStreamingCoverageBias", 			variantFloat = 2.0 },

		-- We use a lower shadow mode, but override the shadow
		-- map size to be larger and reduce aliasing.
		{ setting = "VolumetricLighting",    	variantUInt = 1 },
		{ setting = "UseOnlyLowShadowDrawStyle",variantBool = true },
		{ setting = "NearShadowMapSizeOverride",variantUInt = 2048 },
		{ setting = "FarShadowMapSizeOverride",	variantUInt = 1024 },
		
		{ setting = "VerticalSync",          			variantBool = true },
		{ setting = "DynamicVerticalSync",   			variantBool = false },
		{ setting = "FrameRateLimit", 		 			variantUInt = 0 },

		-- empty string = do not override "GameplayScale" default set above
		{ setting = "Autoconfig_GameplayScaleTargetResolution", variantString = "" },
		{ setting = "resolution",            					variantString = "1920:1080:1:60" },
		
		-- Gameplay settings specific to this platform
		{ setting = "InputDeviceType",    variantInt = 1 },

		{ setting = "AmbientOcclusion",      variantUInt = 2 },

		{ setting = "DynamicResolutionScaleMin",					variantFloat = 0.9 },
		{ setting = "DynamicResolutionFramesBeforeDownsample",		variantUInt = 15 },
		{ setting = "DynamicResolutionFramesBeforeUpsample",		variantUInt = 25 },
		{ setting = "DynamicResolutionDesiredFrameTime",			variantFloat = 16.0 },
		{ setting = "DynamicResolutionAllowedFrameTimeVariance",	variantFloat = 0.6 },
		{ setting = "DynamicResolutionAdjustmentFactor",			variantFloat = 1.0 },
	},
	autoconfig_xbox_one_x = -- Applied if we are running on an xbox one x
	{
		-- Output Resolution: 1440p
		-- Target: 1440p 30fps

		{ setting = "Gen7",                  	variantBool = false },
		{ setting = "AnimationQuality",      	variantUInt = 3 },
		{ setting = "AntiAliasing",          	variantFloat = 1.0 },
		{ setting = "AudioOutputQuality",    	variantUInt = 3 },
		{ setting = "GameplayScale",         	variantFloat = 1.0 },
		{ setting = "GraphicsQuality",       	variantUInt = 1 },
		{ setting = "HDR",                   	variantBool = true },
		{ setting = "MoviePlayerPixelCount", 	variantInt = 1440000 },
		{ setting = "ModelDetail",           	variantUInt = 1 },
		{ setting = "Physics",               	variantUInt = 0 },
		{ setting = "TextureDetail",         	variantUInt = 1 },

		{ setting = "TextureStreamingEnabled", 					variantBool = true },
		{ setting = "TextureStreamingMinMipCount", 				variantUInt = 9 },			-- 256
		{ setting = "TextureStreamingMaxMipCount", 				variantUInt = 13 }, 		-- 8096x8096
		{ setting = "TextureStreamingMaxMemoryUsage", 			variantUInt = 1024 },
		{ setting = "TextureStreamingMaxCriticalCachedMemory", 	variantUInt = 80 },
		{ setting = "TextureStreamingMaxConcurrentStreams", 	variantUInt = 32 },
		{ setting = "TextureStreamingCoverageBias", 			variantFloat = 2.0 },
		
		-- We use a lower shadow mode, but override the shadow
		-- map size to be larger and reduce aliasing.
		{ setting = "VolumetricLighting",    			variantUInt = 0 },
		{ setting = "UseOnlyLowShadowDrawStyle",		variantBool = true },
		{ setting = "NearShadowMapSizeOverride",		variantUInt = 2048 },
		{ setting = "FarShadowMapSizeOverride",			variantUInt = 1024 },
		{ setting = "ShadowCascadeOverride",			variantInt  = 1 },
		{ setting = "WaterReflectionsDisableOverride",	variantBool  = true },
		
		-- Re-enable when our frame rate is better.
		{ setting = "VerticalSync",          			variantBool = true },
		{ setting = "DynamicVerticalSync",   			variantBool = true },
		{ setting = "DynamicVerticalSyncThreshold",   	variantFloat = 4.0 },
		{ setting = "FrameRateLimit", 		 			variantUInt = 0 },

		-- empty string = do not override "GameplayScale" default set above
		{ setting = "Autoconfig_GameplayScaleTargetResolution", variantString = "" },
		{ setting = "resolution",            					variantString = "2560:1440:1:30" },

		-- Gameplay settings specific to this platform
		{ setting = "InputDeviceType",    		variantInt = 1 },

		{ setting = "AmbientOcclusion",      variantUInt = 1 },

		{ setting = "DynamicResolutionScaleMin",					variantFloat = 0.875 },
		{ setting = "DynamicResolutionFramesBeforeDownsample",		variantUInt = 15 },
		{ setting = "DynamicResolutionFramesBeforeUpsample",		variantUInt = 25 },
		{ setting = "DynamicResolutionDesiredFrameTime",			variantFloat = 32.0 },
		{ setting = "DynamicResolutionAllowedFrameTimeVariance",	variantFloat = 1.5 },
		{ setting = "DynamicResolutionAdjustmentFactor",			variantFloat = 1.0 },
	},
	autoconfig_xbox_one_s = -- Applied if we are running on an xbox one / xbox one s
	{
		-- Output Resolution: 900p
		-- Target: 900p 30fps

		{ setting = "Gen7",                  	variantBool = false },
		{ setting = "AnimationQuality",      	variantUInt = 3 },
		{ setting = "AntiAliasing",          	variantFloat = 0.5 },
		{ setting = "AudioOutputQuality",    	variantUInt = 4 },
		{ setting = "GameplayScale",         	variantFloat = 1.0 },
		{ setting = "GraphicsQuality",       	variantUInt = 1 },
		{ setting = "HDR",                   	variantBool = true },
		{ setting = "MoviePlayerPixelCount", 	variantInt = 1440000 },
		{ setting = "ModelDetail",           	variantUInt = 1 },
		{ setting = "Physics",               	variantUInt = 0 },
		{ setting = "TextureDetail",         	variantUInt = 2 },
		
		{ setting = "TextureStreamingEnabled", 					variantBool = true },
		{ setting = "TextureStreamingMinMipCount", 				variantUInt = 6 },			-- 32
		{ setting = "TextureStreamingMaxMipCount", 				variantUInt = 11 }, 		-- 1024x1024
		{ setting = "TextureStreamingMaxMemoryUsage", 			variantUInt = 128 },
		{ setting = "TextureStreamingMaxCriticalCachedMemory", 	variantUInt = 16 },
		{ setting = "TextureStreamingMaxConcurrentStreams", 	variantUInt = 32 },
		{ setting = "TextureStreamingCoverageBias", 			variantFloat = 2.0 },

		{ setting = "VolumetricLighting",    	variantUInt = 0 },
		{ setting = "UseOnlyLowShadowDrawStyle",variantBool = true },
		{ setting = "WaterReflectionsDisableOverride",	variantBool  = true },
		
		-- Re-enable when our frame rate is better.
		{ setting = "VerticalSync",          			variantBool = true },
		{ setting = "DynamicVerticalSync",   			variantBool = true },
		{ setting = "DynamicVerticalSyncThreshold",   	variantFloat = 4.0 },
		{ setting = "FrameRateLimit", 		 			variantUInt = 0 },

		-- empty string = do not override "GameplayScale" default set above
		{ setting = "Autoconfig_GameplayScaleTargetResolution", variantString = "" },
		{ setting = "resolution",            					variantString = "1600:900:1:30" },

		-- Gameplay settings specific to this platform
		{ setting = "InputDeviceType",    		variantInt = 1 },

		{ setting = "AmbientOcclusion",      variantUInt = 1 },

		{ setting = "DynamicResolutionScaleMin",					variantFloat = 0.9 },
		{ setting = "DynamicResolutionFramesBeforeDownsample",		variantUInt = 15 },
		{ setting = "DynamicResolutionFramesBeforeUpsample",		variantUInt = 25 },
		{ setting = "DynamicResolutionDesiredFrameTime",			variantFloat = 32.0 },
		{ setting = "DynamicResolutionAllowedFrameTimeVariance",	variantFloat = 1.5 },
		{ setting = "DynamicResolutionAdjustmentFactor",			variantFloat = 1.0 },
	},
	autoconfig_xbox_one = -- Applied if we are running on an xbox one / xbox one s
	{
		-- Output Resolution: 900p
		-- Target: 900p 30fps

		{ setting = "Gen7",                  	variantBool = false },
		{ setting = "AnimationQuality",      	variantUInt = 3 },
		{ setting = "AntiAliasing",          	variantFloat = 0.5 },
		{ setting = "AudioOutputQuality",    	variantUInt = 4 },
		{ setting = "GameplayScale",         	variantFloat = 1.0 },
		{ setting = "GraphicsQuality",       	variantUInt = 1 },
		{ setting = "HDR",                   	variantBool = true },
		{ setting = "MoviePlayerPixelCount", 	variantInt = 1440000 },
		{ setting = "ModelDetail",           	variantUInt = 1 },
		{ setting = "Physics",               	variantUInt = 0 },
		{ setting = "TextureDetail",         	variantUInt = 2 },
		
		{ setting = "TextureStreamingEnabled", 					variantBool = true },
		{ setting = "TextureStreamingMinMipCount", 				variantUInt = 6 },			-- 32
		{ setting = "TextureStreamingMaxMipCount", 				variantUInt = 11 }, 		-- 1024x1024
		{ setting = "TextureStreamingMaxMemoryUsage", 			variantUInt = 128 },
		{ setting = "TextureStreamingMaxCriticalCachedMemory", 	variantUInt = 16 },
		{ setting = "TextureStreamingMaxConcurrentStreams", 	variantUInt = 32 },
		{ setting = "TextureStreamingCoverageBias", 			variantFloat = 2.0 },

		{ setting = "VolumetricLighting",    	variantUInt = 0 },
		{ setting = "UseOnlyLowShadowDrawStyle",variantBool = true },
		{ setting = "WaterReflectionsDisableOverride",	variantBool  = true },
				
		-- Re-enable when our frame rate is better.
		{ setting = "VerticalSync",          			variantBool = true },
		{ setting = "DynamicVerticalSync",   			variantBool = true },
		{ setting = "DynamicVerticalSyncThreshold",   	variantFloat = 4.0 },
		{ setting = "FrameRateLimit", 		 			variantUInt = 0 },

		-- empty string = do not override "GameplayScale" default set above
		{ setting = "Autoconfig_GameplayScaleTargetResolution", variantString = "" },
		{ setting = "resolution",            					variantString = "1600:900:1:30" },

		-- Gameplay settings specific to this platform
		{ setting = "InputDeviceType",    		variantInt = 1 },

		{ setting = "AmbientOcclusion",      variantUInt = 1 },

		{ setting = "DynamicResolutionScaleMin",					variantFloat = 0.9 },
		{ setting = "DynamicResolutionFramesBeforeDownsample",		variantUInt = 15 },
		{ setting = "DynamicResolutionFramesBeforeUpsample",		variantUInt = 25 },
		{ setting = "DynamicResolutionDesiredFrameTime",			variantFloat = 32.0 },
		{ setting = "DynamicResolutionAllowedFrameTimeVariance",	variantFloat = 1.5 },
		{ setting = "DynamicResolutionAdjustmentFactor",			variantFloat = 1.0 },
	},
	
	autoconfig_ps5 = -- Applied if we are running on a PS5
	{
		-- Output Resolution: 1080p
		-- Target: 1080p 60fps --
		{ setting = "Gen7",                                     variantBool = false },
		{ setting = "AnimationQuality",                         variantUInt = 1 },
		{ setting = "AntiAliasing",                             variantFloat = 1.0 },
		{ setting = "AudioOutputQuality",                       variantUInt = 5 },
		{ setting = "GameplayScale",                            variantFloat = 1.0 },
		{ setting = "GraphicsQuality",                          variantUInt = 2 },
		{ setting = "HDR",                                      variantBool = true },
		{ setting = "MoviePlayerPixelCount",                    variantInt = 2073600 },
		{ setting = "ModelDetail",                              variantUInt = 2 },
		{ setting = "Physics",                                  variantUInt = 2 },
		{ setting = "TextureDetail",                            variantUInt = 2 },
		{ setting = "VariableRateShading",                      variantBool = false }, -- disabled VRS in favor of upcoming dynamic resolution
		{ setting = "TextureStreamingEnabled",                  variantBool = true },
		{ setting = "TextureStreamingMinMipCount",              variantUInt = 8 }, -- 128
		{ setting = "TextureStreamingMaxMipCount",              variantUInt = 12 }, -- 2048x2048
		{ setting = "TextureStreamingMaxMemoryUsage",           variantUInt = 512 },
		{ setting = "TextureStreamingMaxCriticalCachedMemory",  variantUInt = 64 },
		{ setting = "TextureStreamingMaxConcurrentStreams",     variantUInt = 32 },
		{ setting = "TextureStreamingCoverageBias",             variantFloat = 2.0 },

		-- We use a lower shadow mode, but override the shadow
		-- map size to be larger and reduce aliasing.
		{ setting = "VolumetricLighting",        variantUInt = 1 },
		{ setting = "UseOnlyLowShadowDrawStyle", variantBool = true },
		{ setting = "NearShadowMapSizeOverride", variantUInt = 2048 },
		{ setting = "FarShadowMapSizeOverride",  variantUInt = 1024 },	
		{ setting = "VerticalSync",              variantBool = true },
		{ setting = "DynamicVerticalSync",       variantBool = false },
		{ setting = "FrameRateLimit",            variantUInt = 0 },

		-- if the resolution is greater than this it scales otherwise uses what the video
		-- out of the PS5 reports as expected resolution. ps5 can run 4k no problems
		-- same as the xbox_series_x, ps5 pro can run 8k but memory for buffers can be an issue so
		-- it scales if resolution is beyond 4k.
		{ setting = "Autoconfig_GameplayScaleTargetResolution", variantString = "3840:2160:1:60" },
		{ setting = "windowmode",                               variantUInt = 1 },

		-- Gameplay settings specific to this platform
		{ setting = "InputDeviceType",                           variantInt = 1 },
		{ setting = "AmbientOcclusion",                          variantUInt = 2 },
		{ setting = "DynamicResolutionScaleMin",                 variantFloat = 0.9 },
		{ setting = "DynamicResolutionFramesBeforeDownsample",   variantUInt = 15 },
		{ setting = "DynamicResolutionFramesBeforeUpsample",     variantUInt = 25 },
		{ setting = "DynamicResolutionDesiredFrameTime",         variantFloat = 16.0 },
		{ setting = "DynamicResolutionAllowedFrameTimeVariance", variantFloat = 0.6 },
		{ setting = "DynamicResolutionAdjustmentFactor",         variantFloat = 1.0 },
	},

	-- TODO: Instead of tying those settings to "graphicquality" in code, consider moving the logic to data.
	-- Settings that are set to lowest possible and LOCKED when "graphicsquality" setting is set to low (0)
	graphicsquality_low_and_locked =
	{
		{ setting = "AnimationQuality",      variantUInt = 3 },
		{ setting = "AntiAliasing",          variantFloat = 0 },
		{ setting = "HDR",                   variantBool = false },
		{ setting = "ModelDetail",           variantUInt = 0 },
		{ setting = "MoviePlayerPixelCount", variantInt = 2073600 },
		{ setting = "Physics",               variantUInt = 0 },
		{ setting = "TextureDetail",         variantUInt = 2 },
		{ setting = "AmbientOcclusion",      variantUInt = 0 },
		{ setting = "TextureStreamingEnabled", 				variantBool = true },
		{ setting = "TextureStreamingMinMipCount", 			variantUInt = 6 },			
		{ setting = "TextureStreamingMaxMipCount", 			variantUInt = 11 }, 		
		{ setting = "TextureStreamingMaxMemoryUsage", 		variantUInt = 128 },
		{ setting = "TextureStreamingMaxConcurrentStreams", 	variantUInt = 32 },
		{ setting = "TextureStreamingCoverageBias", 			variantFloat = 2.0 },
	},
	-- Settings that are set to lowest possible when "graphicsquality" setting is set to low (0)
	graphicsquality_low =
	{
		{ setting = "VolumetricLighting",    variantUInt = 3 },
	},
}

-- Autoconfigure Graphics Settings
-- For an overview of how this works:
-- http://relicwiki/display/CARD/Graphics+Setting+Autodetection
--
-- For the definition/differences in computer spec between gen 7 8 and 9:
-- http://relicwiki/display/CARD/Min+Spec for the definition of gen 7 8 and 9
autoconfig =
{
	-- System meets or exceeds gen 8 spec and should use normal assets + rendering pipeline
	{
		conditions =
		{
			-- A gen 8 CPU is defined as an i5 4460T (4 cores 4 threads @ 1.9GHz base frequency)
			-- This results in a cpu score of 7600. Setting threshold to 7500 to give some breathing room in base
			-- frequency reporting inaccuracies (i.e. if base frequency gets reported as low as 1.875 GHz)
			{ spec = "Platform",        operator = "equal",            value = 0 }, -- PC
			{ spec = "CpuCoreCount",    operator = "greaterthanequal", value = 4 },
			{ spec = "CpuScore",        operator = "greaterthanequal", value = 7500 },
			{ spec = "RamCapacity",     operator = "greaterthanequal", value = 6145 }, -- 6 GB + 1 MB
			{ spec = "GpuType",         operator = "greaterthanequal", value = 1 },
			{ spec = "GpuVramCapacity", operator = "greaterthanequal", value = 1950 }
		},
		actions = { "autoconfig_baseline" }
	},
	{
		conditions =
		{
			{ spec = "Platform",      operator = "equal",    value = 0 }, -- PC
			{ spec = "SettingsGroup", operator = "notexist", value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_gen7" }
	},

	-- CPU Performance dependent groups
	{
		conditions =
		{
			{ spec = "Platform",      operator = "equal",   value = 0 }, -- PC
			{ spec = "CpuScore",      operator = "between", value = { lower = 7500, upper = 14999 } },
			{ spec = "SettingsGroup", operator = "exist",   value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_cpu_low" }
	},
	{
		conditions =
		{
			{ spec = "Platform",      operator = "equal",   value = 0 }, -- PC
			{ spec = "CpuScore",      operator = "between", value = { lower = 15000, upper = 22999 } },
			{ spec = "SettingsGroup", operator = "exist",   value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_cpu_medium" }
	},
	{
		conditions =
		{
			{ spec = "Platform",      operator = "equal",            value = 0 }, -- PC
			{ spec = "CpuScore",      operator = "greaterthanequal", value = 23000 },
			{ spec = "SettingsGroup", operator = "exist",            value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_cpu_high" }
	},

	-- RAM Capacity dependent groups
	{
		conditions =
		{
			-- 8 GB
			{ spec = "Platform",      operator = "equal",   value = 0 }, -- PC
			{ spec = "RamCapacity",   operator = "between", value = { lower = 8000, upper = 9999 } },
			{ spec = "SettingsGroup", operator = "exist",   value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_ram_low" }
	},
	{
		conditions =
		{
			-- 10 GB
			{ spec = "Platform",      operator = "equal",   value = 0 }, -- PC
			{ spec = "RamCapacity",   operator = "between", value = { lower = 10000, upper = 11999 } },
			{ spec = "SettingsGroup", operator = "exist",   value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_ram_medium" }
	},
	{
		conditions =
		{
			-- 12 GB
			{ spec = "Platform",      operator = "equal",            value = 0 }, -- PC
			{ spec = "RamCapacity",   operator = "greaterthanequal", value = 12000 },
			{ spec = "SettingsGroup", operator = "exist",            value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_ram_high" }
	},

	-- GPU Performance dependent groups
	-- For definition of "GpuType", see drivers.rdo in the Essence Editor
	{
		conditions =
		{
			{ spec = "Platform",      operator = "equal", value = 0 }, -- PC
			{ spec = "GpuType",       operator = "equal", value = 1 },
			{ spec = "SettingsGroup", operator = "exist", value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_gpu_gen8_720p" }
	},
	{
		conditions =
		{
			{ spec = "Platform",      operator = "equal", value = 0 }, -- PC
			{ spec = "GpuType",       operator = "equal", value = 2 },
			{ spec = "SettingsGroup", operator = "exist", value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_gpu_gen8_1080p" }
	},
	{
		conditions =
		{
			{ spec = "Platform",      operator = "equal", value = 0 }, -- PC
			{ spec = "GpuType",       operator = "equal", value = 3 },
			{ spec = "SettingsGroup", operator = "exist", value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_gpu_gen9_1080p" }
	},
	{
		conditions =
		{
			{ spec = "Platform",      operator = "equal", value = 0 }, -- PC
			{ spec = "GpuType",       operator = "equal", value = 4 },
			{ spec = "SettingsGroup", operator = "exist", value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_gpu_gen9_2160p" }
	},

	-- GPU VRAM dependent groups
	{
		conditions =
		{
			-- 2 GB
			{ spec = "Platform",        operator = "equal",   value = 0 }, -- PC
			{ spec = "GpuVramCapacity", operator = "between", value = { lower = 1950, upper = 3999 } },
			{ spec = "SettingsGroup",   operator = "exist",   value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_gpu_vram_low" }
	},
	{
		conditions =
		{
			-- 4 GB
			{ spec = "Platform",        operator = "equal",   value = 0 }, -- PC
			{ spec = "GpuVramCapacity", operator = "between", value = { lower = 4000, upper = 5999 } },
			{ spec = "SettingsGroup",   operator = "exist",   value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_gpu_vram_medium" }
	},
	{
		conditions =
		{
			-- 6 GB
			{ spec = "Platform",        operator = "equal",            value = 0 }, -- PC
			{ spec = "GpuVramCapacity", operator = "greaterthanequal", value = 6000 },
			{ spec = "SettingsGroup",   operator = "exist",            value = "autoconfig_baseline" }
		},
		actions = { "autoconfig_gpu_vram_high" }
	},

	-- Special: Audio output quality depends on cpu and ram together.
	-- Audio quality is set to high if CPU and RAM are both high
	-- Audio quality is set to medium if CPU and RAM are both medium or better
	-- Otherwise, audio quality is set to low
	{
		conditions =
		{
			{ spec = "Platform",      operator = "equal", value = 0 }, -- PC
			{ spec = "SettingsGroup", operator = "exist", value = "autoconfig_cpu_high" },
			{ spec = "SettingsGroup", operator = "exist", value = "autoconfig_ram_high" },
		},
		actions = { "autoconfig_audio_high" }
	},
	{
		conditions =
		{
			{ spec = "Platform",      operator = "equal", value = 0 }, -- PC
			{ spec = "SettingsGroup", operator = "exist", value = "autoconfig_cpu_medium" },
			{ spec = "SettingsGroup", operator = "exist", value = "autoconfig_ram_medium" },
		},
		actions = { "autoconfig_audio_medium" }
	},
	{
		conditions =
		{
			{ spec = "Platform",      operator = "equal", value = 0 }, -- PC
			{ spec = "SettingsGroup", operator = "exist", value = "autoconfig_cpu_medium" },
			{ spec = "SettingsGroup", operator = "exist", value = "autoconfig_ram_high" },
		},
		actions = { "autoconfig_audio_medium" }
	},
	{
		conditions =
		{
			{ spec = "Platform",      operator = "equal", value = 0 }, -- PC
			{ spec = "SettingsGroup", operator = "exist", value = "autoconfig_cpu_high" },
			{ spec = "SettingsGroup", operator = "exist", value = "autoconfig_ram_medium" },
		},
		actions = { "autoconfig_audio_medium" }
	},
	{
		conditions =
		{
			{ spec = "Platform",      operator = "equal",    value = 0 }, -- PC
			{ spec = "SettingsGroup", operator = "notexist", value = "autoconfig_audio_medium" },
			{ spec = "SettingsGroup", operator = "notexist", value = "autoconfig_audio_high" },
		},
		actions = { "autoconfig_audio_low" }
	},

	-- Special fixed configuration when running on different console sku's.
	{
		conditions =
		{
			{ spec = "Platform",    	operator = "equal", value = 1 },
		},
		actions = { "autoconfig_xbox_series_x" }
	},
	{
		conditions =
		{
			{ spec = "Platform",    	operator = "equal", value = 2 },
		},
		actions = { "autoconfig_xbox_series_s" }
	},
	{
		conditions =
		{
			{ spec = "Platform",    	operator = "equal", value = 3 },
		},
		actions = { "autoconfig_xbox_one_x" }
	},
	{
		conditions =
		{
			{ spec = "Platform",    	operator = "equal", value = 4 },
		},
		actions = { "autoconfig_xbox_one_s" }
	},
	{
		conditions =
		{
			{ spec = "Platform",    	operator = "equal", value = 5 },
		},
		actions = { "autoconfig_xbox_one" }
	},
	{
		conditions =
		{
			{ spec = "Platform",    	operator = "equal", value = 6 },
		},
		actions = { "autoconfig_ps5" }
	}
}

uiCategories = 
{	
	-- Controls
	{
		key = "Control",
		data = "SettingsModalPageControlsPane.xaml",
		nameLocID = 11149469,
		hardwareAvailability = HA_PC,
		groups = 
		{
			-- General
			{
				nameLocID = 11050160,
				settings = 
				{
					{ setting = "StickySelection" },
					{ setting = "SwapShiftAndAltKeys" },
					{ setting = "ExclusiveControlGroups" },
					{ setting = "IdleVillagerPickType" }, -- applies to all entities of unit type "worker", includes fishing boats
					{ setting = "IdleMilitaryPickType" },
					{ setting = "FindAndCyclePickType" },
					{ setting = "CycleSubselectionPickType" },
					{ setting = "FocusSelectedFollow" },
					{ setting = "CommandQueueMode" },
				}
			},
			{
				-- Mouse
				nameLocID = 11166208,
				settings = 
				{
					{ setting = "MouseCursorSpeed" },
				}
			}
		}
	},
	-- Camera
	{
		key = "Camera",
		data = "SystemConfigGenericPane.xaml",
		nameLocID = 11166675,
		hardwareAvailability = HA_PC,
		groups = 
		{
			-- Pan
			{
				nameLocID = 11197430,
				settings = 
				{
					{ setting = "EnablePanAccelerationAndSmoothing" },
					{ setting = "ActiveMousePanHandler" },
					{ setting = "MouseButtonPanDirection" },
					{ setting = "MouseButtonPanSpeedFactor" },
					{ setting = "ActiveScreenEdgePanHandler" },
					{ setting = "EdgePan" },
					{ setting = "BoxSelectingDisablesEdgePan" },
					{ setting = "EdgePanSpeedFactor" },
					{ setting = "ActiveKeyboardPanHandler" },
					{ setting = "KeyboardPanSpeedFactor" },
				}
			},
			-- Zoom
			{
				nameLocID = 11197431,
				settings = 
				{
					{ setting = "CameraMode" },
					{ setting = "ScrollWheelZoom" },
					{ setting = "DistanceRateWheelFactor" },
				}
			},
		}
	},
	-- Game
	{
		key = "Game",
		data = "SystemConfigGenericPane.xaml",
		nameLocID = 11149466,
		hardwareAvailability = HA_PC,
		groups = 
		{
			-- General
			{
				nameLocID = 11050160,
				settings = 
				{
					{ setting = "DynamicTraining" },
					{ setting = "PlayerColour" },
					{ setting = "BandboxSelect" },
					{ setting = "CampaignDifficulty" },
					{ setting = "CampaignAutoSave" },
					{ setting = "GameWindowActiveWhenLoaded" },
					{ setting = "TooltipDelay" },
					{ setting = "RightClickGarrison" },
					{ setting = "SingleActionWaypointMarkers" },
					{ setting = "QueuedCommandPriority" },
					{ setting = "AttackMoveBehaviour" },
				}
			},
			-- Event Notifications
			{
				nameLocID = 11166971,
				dataTemplate = "WrapPanelThreeColumnsTemplate",
				settings = 
				{
					{ setting = "eventAgeUp" },
					{ setting = "eventBuildingComplete" },
					{ setting = "eventUnitComplete" },
					{ setting = "eventUpgradeComplete" },
					{ setting = "eventUnderAttack" },
					{ setting = "eventPopulationCap" },
					{ setting = "eventUnitFound" },
					{ setting = "eventObjectFound" },
					{ setting = "eventMajorGameModeObjectives" },
					{ setting = "eventMinorGameModeObjectives" },
					{ setting = "eventMinorCampaignObjectives" },
				}
			},
		}
	},
	{
		key = "UI",
		data = "SystemConfigGenericPane.xaml",
		nameLocID = 11149470,
		hardwareAvailability = HA_PC,
		groups = 
		{
			--In-Game HUD
			{
				nameLocID = 11167010,
				settings = 
				{
					{ setting = "HealthBarVisibilityMode" },
					{ setting = "ConstructionProgressVisibilityMode" },
					{ setting = "LandmarkConstructionProgressVisibilityMode" },
					{ setting = "DistrictTierIconVisibilityMode" },
					{ setting = "ShowGameTimer" },
					{ setting = "ShowPlayerScores" },
					{ setting = "GlobalBuildQueueVisibility" },
					{ setting = "MinimapZoomLevel" },
					{ setting = "BuildingGridOverlay" },
					{ setting = "ShowControlGroup" },
					{ setting = "ShowIdleVillagerIcons" },
					{ setting = "ShowCondensedVictoryObjectives" },
				}
			},
			-- Minimap
			{
				nameLocID = 11167009,
				dataTemplate = "WrapPanelThreeColumnsTemplate",
				settings = 
				{
					{ setting = "MinimapBuildings" },
					{ setting = "MinimapUnits" },
					{ setting = "MinimapResources" },
					{ setting = "MinimapObjects" },
					{ setting = "MinimapPingNotifications" },
					{ setting = "MinimapBuildNotifications" },
					{ setting = "MinimapAttackNotifications" },
				}
			}
		}
	},
	-- Graphics
	{
		key = "Graphics",
		data = "SystemConfigGenericPane.xaml",
		nameLocID = 11037964,
		hardwareAvailability = HA_PC,
		groups = 
		{
			-- Display
			{
				nameLocID = 11167049,
				settings = 
				{
					{ setting = "windowmode" },
					{ setting = "resolution" },
					{ setting = "gameplayscale" },
					{ setting = "MouseClamp" },
				}
			},
			-- Performance & Quality
			{
				nameLocID = 11167050,
				settings = 
				{
					{ setting = "GraphicsQuality" },
					{ setting = "HDR" },
					{ setting = "animationquality" },
					{ setting = "VolumetricLighting" },
					{ setting = "AmbientOcclusion" },
					{ setting = "TextureDetail" },
					{ setting = "ModelDetail" },
					{ setting = "AntiAliasing" },
					{ setting = "Physics" },
					{ setting = "VerticalSync" },
					{ setting = "FrameRateLimit" },
					{ setting = "MoviePlayerPixelCount" },
				},
				linkedSettings =
				{
					{ setting = "LdrGamma" },
				},
			}
		}
	},
	-- Audio
	{
		key = "Audio",
		data = "SystemConfigGenericPane.xaml",
		nameLocID = 11149468,
		hardwareAvailability = HA_PC,
		groups = 
		{
				-- General
			{
				nameLocID = 11050160,
				settings = 
				{
					{ setting = "audioBalance" },
				}
			},
			{
				-- Volume
				nameLocID = 11197435,
				settings = 
				{
					{ setting = "masterVolume" },
					{ setting = "musicVolume" },
					{ setting = "speechVolume" },
					{ setting = "sfxVolume" },
					{ setting = "tauntsVolume" },
					{ setting = "VoiceChatVolume" }
				}
			},
			{
				-- Configuration
				nameLocID = 11167085,
				settings = 
				{
					{ setting = "AudioOutputQuality" },
					{ setting = "AudioDynamicRange" },
				}
			}
		}
	},
	-- Online
	{
		key = "Online",
		data = "SystemConfigGenericPane.xaml",
		nameLocID = 23001,
		hardwareAvailability = HA_PC,
		groups = 
		{
			-- Voice Chat
			{
				nameLocID = 11192945,
				settings = 
				{
					{ setting = "UseVoiceChat" },
					{ setting = "VoiceChatMethod" },
					{ setting = "AudioOutputDevice" },
					{ setting = "AudioInputDevice" },
					{ setting = "MuteMicrophone" },
				}
			},
			-- Game Chat
			{
				nameLocID = 11167108,
				settings = 
				{
					{ setting = "ShowChatTimeStamp" },
					{ setting = "AllowMessages" },
					{ setting = "PingChatMessages" },
					{ setting = "EnableTaunts" },
				}
			},
			{
				-- Friends
				nameLocID = 11167107,
				settings = 
				{
					{ setting = "AllowFriendRequests" },
				}
			},
			{
				-- Privacy
				nameLocID = 11204583,
				settings = 
				{
					{ setting = "OnlinePresence" },
					{ setting = "BlockUGC" },
				}
			},
			{
				-- Cross Play
				nameLocID = 999986,
				uiModelTypeOverride = "CrossPlaySystemConfigGroupModel",
				settings = 
				{
					{ setting = "CrossNetwork" },
				}
			},
		}
	},
	-- Accessibility
	{
		key = "Accessibility",
		data = "SystemConfigGenericPane.xaml",
		nameLocID = 11149467,
		hardwareAvailability = HA_PC,
		groups = 
		{
			-- General
			{
				nameLocID = 11050160,
				dataTemplate = "SettingNoTitleGroupTemplate",
				settings = 
				{
					{ setting = "CustomizeGameColors" },
				}
			},
			{
				-- Visibility
				nameLocID = 11167115,
				dataTemplate = "AccessibilityTitlePlusMessagesTemplate",
				settings = 
				{
					{ setting = "StrongHighContrast" },
					{ setting = "UIScale" },
					{ setting = "CursorScale" },
					{ setting = "UniqueMinimapPlayerIcons" },
					{ setting = "SlidingNotifications" },
				}
			},
			{
				-- Subtitles
				nameLocID = 11197432,
				settings = 
				{
					{ setting = "SubtitleVisibility" },
					{ setting = "CaptionScale" },
					{ setting = "SubtitlePosition" },
					{ setting = "SubtitleFont" },
					{ setting = "SubtitleFontColor" },
					{ setting = "SubtitleBackgroundColor" },
				}
			},
			{
			-- Comfort
				nameLocID = 11167117,
				settings = 
				{
					{ setting = "ScreenShakeEffect" },
					{ setting = "DynamicCamera" },
					{ setting = "ButtonHoldTiming" },
					{ setting = "ReduceFlashes" },
				}
			},
			-- Profile Icons
			{
				nameLocID = 11167118,
				settings = 
				{
					{ setting = "DisplayKeyboardChatIcon" },
					{ setting = "DisplayNoAudioIcon" },
				}
			},
			-- Narration
			{
				nameLocID = 11197433,
				dataTemplate = "EnglishOnlySettingsTemplate",
				settings = 
				{
					{ setting = "TextToSpeechForChatMessagesPc" },
					{ setting = "ReadIncomingTextChat" },
					{ setting = "UIElementNarration" },
					{ setting = "SpeechToText" }
				}
			},
		},
	},
	
	-----------------------------------------------------
	-----------------Xbox Categories---------------------
	-----------------------------------------------------
	
	-- Xbox Accessibility
	{
		key = "XboxAccessibility",
		data = "XboxSystemConfigGenericPane.xaml",
		nameLocID = 11149467,
		hardwareAvailability = HA_Console,
		groups = 
		{
			-- Visibility
			{
				nameLocID = 11167115,
				settings = 
				{
					{ setting = "StrongHighContrast" },
					{ setting = "SubtitleVisibility" },
					{ setting = "CaptionScale" },
					{ setting = "InGameChatUIScale" },
				}
			},
			-- Narration
			{
				nameLocID = 11197433,
				dataTemplate = "XboxEnglishOnlySettingsTemplate",
				settings = 
				{
					{ setting = "TextToSpeechForChatMessagesXbox" },
					{ setting = "ReadIncomingTextChat" },
					{ setting = "UIElementNarration" },
					{ setting = "SpeechToText" },
				}
			},
		},
	},
	-- Xbox Controls
	{
		key = "XboxControls",
		data = "XboxSystemConfigGenericPane.xaml",
		nameLocID = 11149469,
		hardwareAvailability = HA_Console,
		groups = 
		{
			-- General
			{
				nameLocID = 11050160,
				settings = 
				{
					{ setting = "ControlsVisuals" },
					{ setting = "InputDeviceType" },
					{ setting = "RemapControls" },
					{ setting = "ControllerLightBar" },
					{ setting = "RumbleToggle" },
					{ setting = "RumbleStrength" },
					{ setting = "LeftThumbstickDeadzone" },
					{ setting = "RightThumbstickDeadzone" },
				}
			},
			-- Magnetism
			{
				nameLocID = 1001223,
				settings = 
				{
					{ setting = "CameraSnapIsActive" },
					{ setting = "CameraSnapRadius" },
				}
			},
			-- Reticle Options
			{
				nameLocID = 1001224,
				settings = 
				{
					{ setting = "LooseReticuleMode" },
					{ setting = "LooseReticuleAreaWidth" },
					{ setting = "LooseReticuleSpeed" },
				}
			},
			-- Input Options
			{
				nameLocID = 1001225,
				settings = 
				{
					{ setting = "RadialHoldToggle" },
				}
			},
			-- Control Scheme Alternatives
			{
				nameLocID = 1001226,
				settings = 
				{
					{ setting = "DisableBuildingRallyPoint" },
					{ setting = "DisableUnitRallyPoint" },
				}
			},
			-- Selection Behaviour
			{
				nameLocID = 1001227,
				settings = 
				{
					{ setting = "MilitaryQuickFindBehaviour" },
					{ setting = "VillagerQuickFindBehaviour" },
					{ setting = "VillagerDoublePress" },
					{ setting = "BandboxSelect" },
				}
			},
		}
	},
	-- Xbox Camera
	{
		key = "XboxCamera",
		data = "XboxSystemConfigGenericPane.xaml",
		nameLocID = 11166675,
		hardwareAvailability = HA_Console,
		groups = 
		{
			-- General
			{
				nameLocID = 11050160,
				settings = 
				{
					{ setting = "AnalogPanSpeed" },
					{ setting = "AnalogAccelerationSpeed" },
					{ setting = "EnablePanAccelerationAndSmoothing" },
					{ setting = "MouseButtonPanSpeedFactor" },
					{ setting = "EdgePan" },
					{ setting = "BoxSelectingDisablesEdgePan" },
					{ setting = "EdgePanSpeedFactor" },
					{ setting = "KeyboardPanSpeedFactor" },
					{ setting = "ScrollWheelZoom" },
					{ setting = "DistanceRateWheelFactor" },
					{ setting = "AnalogOrbitSpeed" },
					{ setting = "AnalogzoomSpeed" },
					{ setting = "CameraMode" },
					{ setting = "CameraResetAll" },
				}
			},
			-- Marquee Options
			{
				nameLocID = 1001228,
				settings = 
				{
					{ setting = "MarqueeSizeMaximum" },
					{ setting = "MarqueeSpeed" },
				}
			},
			-- Minimap Options
			{
				nameLocID = 1001253,
				settings = 
				{
					{ setting = "MinimapReticuleSpeed" },
				}
			},
			-- Selection and Camera Behaviour
			{
				nameLocID = 1001229,
				settings = 
				{
					{ setting = "IdleVillagerPickType" },
					{ setting = "IdleMilitaryPickType" },
					{ setting = "FindAndCyclePickType" },
					{ setting = "CycleSubselectionPickType" },
					{ setting = "FocusSelectedFollow" },
					{ setting = "ControlGroupCycleBehaviour" },
				}
			},
		}
	},
	-- Xbox Game
	{
		key = "XboxGame",
		data = "XboxSystemConfigGenericPane.xaml",
		nameLocID = 11149466,
		hardwareAvailability = HA_Console,
		groups = 
		{
			-- General
			{
				nameLocID = 11050160,
				settings = 
				{
					{ setting = "DynamicTraining" },
					{ setting = "ResetTraining" },
					{ setting = "CampaignDifficulty" },
					{ setting = "CampaignAutoSave" },
					{ setting = "QueuedCommandPriority" },
				},
			},
		}
	},
	-- Xbox Visuals
	{
		key = "XboxVisuals",
		data = "XboxSystemConfigGenericPane.xaml",
		nameLocID = 999189,
		hardwareAvailability = HA_Console,
		groups = 
		{
			-- General pt.1
			{
				nameLocID = 11050160,
				settings = 
				{
					{ setting = "AdjustBrightness" },
				},
				linkedSettings =
				{
					{ setting = "LdrGamma" },
					{ setting = "HdrGamma" },
				},
			},
			-- General pt.2 (UI scale has been included twice so will need to be in different group to Adjust Brightness to prevent it from showing at the top)
			{
				nameLocID = 11050160,
				dataTemplate = "XboxSettingNoTitleGroupTemplate",
				settings = 
				{
					{ setting = "AreLabelsActive" },
				},
			},
			-- In-Game HUD
			{
				nameLocID = 1001230,
				settings = 
				{
					{ setting = "PlayerColour" },
					{ setting = "HealthBarVisibilityMode" },
					{ setting = "ConstructionProgressVisibilityMode" },
					{ setting = "ShowGameTimer" },
					{ setting = "SingleActionWaypointMarkers" },
					{ setting = "ShowPlayerInfo" },
					{ setting = "ShowPlayerScores" },
					{ setting = "ShowIdleVillagerIcons" },
					{ setting = "MinimapZoomLevel" },
					{ setting = "ShowControlGroup" },
					{ setting = "ShowHUDKeybindWidgets" },
					{ setting = "ShowHUDCommandWidgets" },
					{ setting = "ShowQuickFindWidgets" },
					{ setting = "SHowVPSWarningMessages"},
					{ setting = "ShowCondensedVictoryObjectives" },
				}
			},
		}
	},
	-- Xbox Audio
	{
		key = "XboxAudio",
		data = "XboxSystemConfigGenericPane.xaml",
		nameLocID = 11149468,
		hardwareAvailability = HA_Console,
		groups = 
		{
			-- General
			{
				nameLocID = 11050160,
				settings = 
				{
					{ setting = "masterVolume" },
					{ setting = "musicVolume" },
					{ setting = "speechVolume" },
					{ setting = "sfxVolume" },
					{ setting = "tauntsVolume" },
				}
			},
			-- Voice Chat
			{
				nameLocID = 11192945,
				settings = 
				{
					{ setting = "UseVoiceChat" },
					{ setting = "VoiceChatVolume" },
				}
			},
			-- Output
			{
				nameLocID = 1001231,
				settings = 
				{
					{ setting = "AudioDynamicRange" },
				}
			},
		}
	},
	-- Xbox Social
	{
		key = "XboxSocial",
		data = "XboxSystemConfigGenericPane.xaml",
		nameLocID = 11197022,
		hardwareAvailability = HA_Console,
		groups = 
		{
			-- General pt.1
			{
				nameLocID = 11050160,
				settings = 
				{
					{ setting = "OnlinePresence" },
				}
			},
			-- General pt.2 (voice chat setting has been referred to in previous category so ensure it appears below online presence by putting it in a different group)
			{
				nameLocID = 11050160,
				dataTemplate = "XboxSettingNoTitleGroupTemplate",
				settings = 
				{
					{ setting = "UseVoiceChat" },
					{ setting = "MuteMicrophone" },
					{ setting = "EnableTaunts" },
					{ setting = "AllowMessages" },
					{ setting = "AllowFriendRequests" },
					{ setting = "CrossNetwork" },
				}
			},
		}
	},
	
	-- Development
	{
		key = "Development",
		data = "SystemConfigGenericPane.xaml",
		nameLocID = 11196617,
		isDebug = true,	
		groups = 
		{
			-- Capture Tool
			{
				nameLocID = 11196618,
				settings = 
				{
					{ setting = "ShowLeaderCrown" },
					{ setting = "ShowCanIssueResult" },
					{ setting = "SelectionBoxOpacity" },
					{ setting = "MoveActionSpawningChance" },
					{ setting = "ShowFormationAction" },
					{ setting = "ShowUnitOcclusion" },
					{ setting = "HdrGamma" },
					{ setting = "HdrMaxBrightness" },
				}
			},
			-- Game Chat (Debug only settings)
			{
				nameLocID = 11167108,
				settings = 
				{
					-- filter setting removed from design so move to Development pane to make that clear
					{ setting = "FilterChat" },
				}
			},
		},
	},
	-- Salisbury Development
	{
		key = "Salisbury",
		data = "XboxSystemConfigGenericPane.xaml",
		nameLocID = 999075,
		isDebug = true,
		hardwareAvailability = HA_Console,
		groups =
		{
			-- Feature Settings
			{
				nameLocID = 999084,
				settings = 
				{
					{ setting = "CycleFormationToggle" },
					{ setting = "ContextualCommandToggle" },
					{ setting = "ContextualMilitaryCommandToggle" },
					{ setting = "SnapToAlertToggle" },
					{ setting = "ActionLinesToggle" },
					{ setting = "ReticleActionLineToggle" },
					{ setting = "ContextualHotkeyIcon" },
					{ setting = "QuickFindBehaviourPreset" },
				}
			},
			-- Controls
			{
				nameLocID = 999083,
				settings =
				{
					{ setting = "MarqueeAccelerationIsActive" },					
					{ setting = "ControllerButtonHoldTime" },
					{ setting = "StickyUnitsIsActive" },
					{ setting = "RecentraliseOnFullPanIsActive" },
					{ setting = "RecentraliseOnRestIsActive" },
					{ setting = "LeftTriggerIsToggle" },
				}
			},
		},
	},
}
