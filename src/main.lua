local mods = rom.mods
mods['SGG_Modding-ENVY'].auto()

---@diagnostic disable: lowercase-global
rom = rom
_PLUGIN = _PLUGIN
game = rom.game
modutil = mods['SGG_Modding-ModUtil']
chalk = mods['SGG_Modding-Chalk']
reload = mods['SGG_Modding-ReLoad']
local lib = mods['adamant-Modpack_Lib'].public

config = chalk.auto('config.lua')
public.config = config

local backup, restore = lib.createBackupSystem()

-- =============================================================================
-- MODULE DEFINITION
-- =============================================================================

public.definition = {
    id       = "TidalRingFix",
    name     = "Tidal Ring Fix",
    category = "BugFixes",
    group    = "Weapons & Attacks",
    tooltip  = "Fixes Tidal Ring not hitting the same mob twice with Circe.",
    default  = true,
    dataMutation = true,
}

-- =============================================================================
-- MODULE LOGIC
-- =============================================================================

local function apply()
    if not ProjectileData or not ProjectileData.PoseidonCastSplashSplinter then return end
    backup(ProjectileData.PoseidonCastSplashSplinter, "ImmunityDuration")
    ProjectileData.PoseidonCastSplashSplinter.ImmunityDuration = 0
end

local function registerHooks()
end

-- =============================================================================
-- Wiring
-- =============================================================================

public.definition.enable = apply
public.definition.disable = restore

local loader = reload.auto_single()

modutil.once_loaded.game(function()
    loader.load(function()
        import_as_fallback(rom.game)
        registerHooks()
        if config.Enabled then apply() end
        if public.definition.dataMutation and not mods['adamant-Core'] then
            SetupRunData()
        end
    end)
end)

lib.standaloneUI(public.definition, config, apply, restore)
