local PANEL = {}
local curent_panel 
local yellow_select = Color(205, 165, 35)

DISCORD_URL = "https://discord.gg/6h9kYhYbuy"

--уж простите но для этих ёбаных букв я использовал ии потому что я ебал эту хуйню
local function toUpper(str)
    if not str then return "" end
    local map = {
        ["а"] = "А", ["б"] = "Б", ["в"] = "В", ["г"] = "Г", ["д"] = "Д",
        ["е"] = "Е", ["ё"] = "Ё", ["ж"] = "Ж", ["з"] = "З", ["и"] = "И",
        ["й"] = "Й", ["к"] = "К", ["л"] = "Л", ["м"] = "М", ["н"] = "Н",
        ["о"] = "О", ["п"] = "П", ["р"] = "Р", ["с"] = "С", ["т"] = "Т",
        ["у"] = "У", ["ф"] = "Ф", ["х"] = "Х", ["ц"] = "Ц", ["ч"] = "Ч",
        ["ш"] = "Ш", ["щ"] = "Щ", ["ъ"] = "Ъ", ["ы"] = "Ы", ["ь"] = "Ь",
        ["э"] = "Э", ["ю"] = "Ю", ["я"] = "Я"
    }
    local result = {}
    local i = 1
    local len = utf8.len(str)
    while i <= len do
        local char = utf8.sub(str, i, i)
        local upper = map[char] or string.upper(char)
        table.insert(result, upper)
        i = i + 1
    end
    return table.concat(result)
end

local function toLower(str)
    if not str then return "" end
    local map = {
        ["А"] = "а", ["Б"] = "б", ["В"] = "в", ["Г"] = "г", ["Д"] = "д",
        ["Е"] = "е", ["Ё"] = "ё", ["Ж"] = "ж", ["З"] = "з", ["И"] = "и",
        ["Й"] = "й", ["К"] = "к", ["Л"] = "л", ["М"] = "м", ["Н"] = "н",
        ["О"] = "о", ["П"] = "п", ["Р"] = "р", ["С"] = "с", ["Т"] = "т",
        ["У"] = "у", ["Ф"] = "ф", ["Х"] = "х", ["Ц"] = "ц", ["Ч"] = "ч",
        ["Ш"] = "ш", ["Щ"] = "щ", ["Ъ"] = "ъ", ["Ы"] = "ы", ["Ь"] = "ь",
        ["Э"] = "э", ["Ю"] = "ю", ["Я"] = "я"
    }
    local result = {}
    local i = 1
    local len = utf8.len(str)
    while i <= len do
        local char = utf8.sub(str, i, i)
        local lower = map[char] or string.lower(char)
        table.insert(result, lower)
        i = i + 1
    end
    return table.concat(result)
end

local Selects = {
    {Title = "Отключиться", Func = function(luaMenu) RunConsoleCommand("disconnect") end},
    {Title = "Главное меню", Func = function(luaMenu) gui.ActivateGameUI() luaMenu:Close() end},
    {Title = "Discord", Func = function(luaMenu) luaMenu:Close() gui.OpenURL(DISCORD_URL)  end},
    {Title = "Роль предателя",
    GamemodeOnly = true,
    CreatedFunc = function(self, parent, luaMenu)
        local container = self:GetParent()
        local selfa = self
        local cachedX = nil

        local btnSOE = vgui.Create( "DLabel", container )
        btnSOE:SetText( "SOE" )
        btnSOE:SetMouseInputEnabled( true )
        btnSOE:SetFont( "ZCity_Small" )
        btnSOE:SetTextColor(Color(240, 240, 240))
        btnSOE.WColor = Color(240, 240, 240, 255)

        function btnSOE:DoClick()
            luaMenu:Close()
            hg.SelectPlayerRole(nil, "soe")
        end

        function btnSOE:Think()
            self.HoverLerp2 = LerpFT(0.2, self.HoverLerp2 or 0, self:IsHovered() and 1 or 0)
            self:SetTextColor(self.WColor:Lerp(yellow_select, self.HoverLerp2))

            if cachedX and IsValid(selfa) then
                self:SetPos(cachedX.soe, selfa:GetY() + (selfa:GetTall() - self:GetTall()) / 2)
            end
        end

        local btnSTD = vgui.Create( "DLabel", container )
        btnSTD:SetText( "STD" )
        btnSTD:SetMouseInputEnabled( true )
        btnSTD:SetFont( "ZCity_Small" )
        btnSTD:SetTextColor(Color(240, 240, 240))
        btnSTD.WColor = Color(240, 240, 240, 255)

        function btnSTD:DoClick()
            luaMenu:Close()
            hg.SelectPlayerRole(nil, "standard")
        end

        function btnSTD:Think()
            self.HoverLerp2 = LerpFT(0.2, self.HoverLerp2 or 0, self:IsHovered() and 1 or 0)
            self:SetTextColor(self.WColor:Lerp(yellow_select, self.HoverLerp2))

            if cachedX and IsValid(selfa) then
                self:SetPos(cachedX.std, selfa:GetY() + (selfa:GetTall() - self:GetTall()) / 2)
            end
        end

        timer.Simple(0, function()
            if not IsValid(selfa) or not IsValid(btnSOE) or not IsValid(btnSTD) then return end

            btnSOE:SizeToContents()
            btnSTD:SizeToContents()

            surface.SetFont(selfa:GetFont())
            local mainTextW = surface.GetTextSize("Роль предателя")

            surface.SetFont(btnSOE:GetFont())
            local soeTextW = surface.GetTextSize("SOE")

            local gapSOE = ScreenScaleH(10)
            local soeX = selfa:GetX() + mainTextW + gapSOE

            local gapSTD = ScreenScaleH(8)
            local stdX = soeX + soeTextW + gapSTD

            cachedX = {soe = soeX, std = stdX}
        end)
    end,
    Func = function(luaMenu)
        
    end,
    },
    {Title = "Достижения", Func = function(luaMenu,pp) 
        hg.DrawAchievmentsMenu(pp)
    end},
    {Title = "Настройки", Func = function(luaMenu,pp) 
        hg.DrawSettings(pp) 
    end},
    {Title = "Внешность", Func = function(luaMenu,pp) hg.CreateApperanceMenu(pp) end},
    {Title = "Назад", Func = function(luaMenu) luaMenu:Close() end},
}

local splasheh = {
    'LIKE HOMICIDED',
    'PLUV PLUV PLUVISKI',
    'LULU IS NOT DEAD | !PLUV',
    'THE TRAITOR WAS KILLED',
    'NAB HOMICIDE SERVER',
    'ALSO TRY MODDED HOMICIDE 2',
    'HOP ON Z-CITY',
    'JOHN Z-CITY',
    ':pluvrare:',
    'SAW51 IS REAL',
    'MORE SMALLTOWN',
    'MORE CLUE2022',
    'BACKROOMS == CLUE',
    'HELL IS NEAR',
    'I WISH YOU GOOD HEALTH, JASON STATHAM'
}

--print(string.upper('I wish you good health, Jason Statham'))
surface.CreateFont("ZC_MM_Title", {
    font = "Bahnschrift",
    size = ScreenScale(40),
    weight = 800,
    antialias = true,
    extended = true
})

surface.CreateFont("ZCity_Small", {
    font = "Bahnschrift",
    size = ScreenScale(15),
    weight = 500,
    antialias = true,
    extended = true
})

surface.CreateFont("ZCity_Tiny", {
    font = "Bahnschrift",
    size = ScreenScale(8),
    weight = 400,
    antialias = true,
    extended = true
})

local Pluv = Material("pluv/pluvkid.jpg")

function PANEL:InitializeMarkup()
    local mapname = game.GetMap()
    local prefix = string.find(mapname, "_")
    if prefix then
        mapname = string.sub(mapname, prefix + 1)
    end
    local gm = splasheh[math.random(#splasheh)] .. " | " .. string.NiceName(mapname) 

    local parsed
    if hg.PluvTown.Active then
        local text = "<font=ZC_MM_Title><colour=200,200,200>    </colour>City</font>\n<font=ZCity_Tiny><colour=140,140,140>" .. gm .. "</colour></font>"
        self.SelectedPluv = table.Random(hg.PluvTown.PluvMats)
        parsed = markup.Parse(text)
    else
        local text = "<font=ZC_MM_Title><colour=200,180,100>Bee</colour><colour=200,200,200>-City</colour></font>\n<font=ZCity_Tiny><colour=140,140,140>" .. gm .. "</colour></font>"
        parsed = markup.Parse(text)
    end
    if parsed and parsed.SizeX then
        self:SetWide(parsed.SizeX + ScreenScale(15))
    end

    return parsed
end

local clr_gray = Color(150, 150, 150, 80)
local clr_verygray = Color(15, 15, 15, 235)

function PANEL:Init()
    self:SetAlpha(0)
    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:SetTitle("")
    self:SetDraggable(false)
    self:SetBorder(false)
    self:SetColorBG(clr_verygray)
    self:SetDraggable(false)
    self:ShowCloseButton(false)
    curent_panel = nil
    self.Title, self.TitleShadow = self:InitializeMarkup()

    timer.Simple(0, function()
        if self.First then
            self:First()
        end
    end)

    self.lDock = vgui.Create("DPanel", self)
    local lDock = self.lDock
    lDock:Dock(LEFT)
    lDock:SetSize(ScrW() / 4, ScrH())
    lDock:DockMargin(ScreenScale(0), ScreenScaleH(90), ScreenScale(10), ScreenScaleH(90))
    lDock.Paint = function(this, w, h)
        if hg.PluvTown.Active then
            surface.SetDrawColor(color_white)
            surface.SetMaterial(self.SelectedPluv or Pluv)
            surface.DrawTexturedRect(0, ScreenScale(27), ScreenScale(35), ScreenScale(27))
        end

        self.Title:Draw(ScreenScale(15), ScreenScale(50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 255, TEXT_ALIGN_LEFT)
    end

    self.Buttons = {}
    for k, v in ipairs(Selects) do
        if v.GamemodeOnly and engine.ActiveGamemode() != "zcity" then continue end
        self:AddSelect(lDock, v.Title, v)
    end

    local bottomDock = vgui.Create("DPanel", self)
    bottomDock:SetPos(ScreenScale(1), ScrH() - ScrH()/10)
    bottomDock:SetSize(ScreenScale(190), ScreenScaleH(40))
    bottomDock.Paint = function(this, w, h) end
    self.panelparrent = vgui.Create("DPanel", self)
    self.panelparrent:SetPos(bottomDock:GetWide()+bottomDock:GetX(), 0)
    self.panelparrent:SetSize(ScrW() - bottomDock:GetWide()*1, ScrH())
    self.panelparrent.Paint = function(this, w, h) end
    
    local git = vgui.Create("DLabel", bottomDock)
    git:Dock(BOTTOM)
    git:DockMargin(ScreenScale(10), 0, 0, 0)
    git:SetFont("ZCity_Tiny")
    git:SetTextColor(clr_gray)
    git:SetText("GitHub: github.com/" .. hg.GitHub_ReposOwner .. "/" .. hg.GitHub_ReposName)
    git:SetContentAlignment(4)
    git:SetMouseInputEnabled(true)
    git:SizeToContents()

    function git:DoClick()
        gui.OpenURL("https://github.com/" .. hg.GitHub_ReposOwner .. "/" .. hg.GitHub_ReposName)
    end

    local version = vgui.Create("DLabel", bottomDock)
    version:Dock(BOTTOM)
    version:DockMargin(ScreenScale(10), 0, 0, 0)
    version:SetFont("ZCity_Tiny")
    version:SetTextColor(clr_gray)
    version:SetText(hg.Version)
    version:SetContentAlignment(4)
    version:SizeToContents()

    local zteam = vgui.Create("DLabel", bottomDock)
    zteam:Dock(BOTTOM)
    zteam:DockMargin(ScreenScale(10), 0, 0, 0)
    zteam:SetFont("ZCity_Tiny")
    zteam:SetTextColor(clr_gray)
    zteam:SetText("Authors: uzelezz, Sadsalat, \nMr.Point, Zac90, Deka, Mannytko")
    zteam:SetContentAlignment(4)
    zteam:SizeToContents()
end

function PANEL:First( ply )
    self:AlphaTo( 255, 0.1, 0, nil )
end

local gradient_d = surface.GetTextureID("vgui/gradient-d")
local gradient_r = surface.GetTextureID("vgui/gradient-u")
local gradient_l = surface.GetTextureID("vgui/gradient-l")

local clr_yellow_glow_top = Color(130, 100, 10, 16)
local clr_yellow_glow_bottom = Color(100, 78, 8, 10)
local clr_yellow_glow_ambient = Color(85, 65, 6, 6)

function PANEL:Paint(w,h)
    draw.RoundedBox( 0, 0, 0, w, h, self.ColorBG )
    hg.DrawBlur(self, 5)
    
    surface.SetDrawColor( self.ColorBG )
    surface.SetTexture( gradient_l )
    surface.DrawTexturedRect(0,0,w,h)
    
    surface.SetDrawColor( clr_yellow_glow_top )
    surface.SetTexture( gradient_d )
    surface.DrawTexturedRect(0,0,w,h)
    
    surface.SetDrawColor( clr_yellow_glow_bottom )
    surface.SetTexture( gradient_r )
    surface.DrawTexturedRect(0,0,w,h)
    
    surface.SetDrawColor( clr_yellow_glow_ambient )
    surface.SetTexture( gradient_l )
    surface.DrawTexturedRect(0,0,w,h)
end

function PANEL:AddSelect( pParent, strTitle, tbl )
    local id = #self.Buttons + 1
    self.Buttons[id] = vgui.Create( "DLabel", pParent )
    local btn = self.Buttons[id]
    btn:SetText( strTitle )
    btn:SetMouseInputEnabled( true )
    btn:SizeToContents()
    btn:SetFont( "ZCity_Small" )
    btn:SetTall( ScreenScale( 15 ) )
    btn:Dock(BOTTOM)
    btn:DockMargin(ScreenScale(15),ScreenScale(1.5),0,0)
    btn.Func = tbl.Func
    btn.HoveredFunc = tbl.HoveredFunc
    local luaMenu = self 
    if tbl.CreatedFunc then tbl.CreatedFunc(btn, self, luaMenu) end
    btn.RColor = Color(220, 220, 220)
    function btn:DoClick()
        -- ,kz оптимизировать надо, но идёт ошибка(кэшировать бы luaMenu.panelparrent вместо вызова его каждый раз)
        if curent_panel == toLower(strTitle) then
            for i = 1, 3 do
                surface.PlaySound("shitty/tap_release.wav")
            end
            luaMenu.panelparrent:AlphaTo(0,0.2,0,function()
                luaMenu.panelparrent:Remove()
                luaMenu.panelparrent = nil
                luaMenu.panelparrent = vgui.Create("DPanel", luaMenu)
                
                luaMenu.panelparrent:SetPos(some_coordinates_x, 0)
                luaMenu.panelparrent:SetSize(some_size_x, some_size_y)
                luaMenu.panelparrent.Paint = function(this, w, h) end
                curent_panel = nil
            end)
            return 
        end
        some_size_x = luaMenu.panelparrent:GetWide()
        some_size_y = luaMenu.panelparrent:GetTall()
        some_coordinates_x = luaMenu.panelparrent:GetX()
        luaMenu.panelparrent:AlphaTo(0,0.2,0,function()
            luaMenu.panelparrent:Remove()
            luaMenu.panelparrent = nil
            luaMenu.panelparrent = vgui.Create("DPanel", luaMenu)
            
            luaMenu.panelparrent:SetPos(some_coordinates_x, 0)
            luaMenu.panelparrent:SetSize(some_size_x, some_size_y)
            luaMenu.panelparrent.Paint = function(this, w, h) end
            btn.Func(luaMenu,luaMenu.panelparrent)
            curent_panel = toLower(strTitle)
        end)
        for i = 1, 3 do
            surface.PlaySound("shitty/tap_depress.wav")
        end
    end

    function btn:Think()
        self.HoverLerp = LerpFT(0.2, self.HoverLerp or 0, (self:IsHovered() or (IsValid(self:GetChild(0)) and self:GetChild(0):IsHovered()) or (IsValid(self:GetChild(0)) and IsValid(self:GetChild(0):GetChild(0)) and self:GetChild(0):GetChild(0):IsHovered())) and 1 or 0)

        local v = self.HoverLerp
        self:SetTextColor(self.RColor:Lerp(yellow_select, v))

        local targetText = (self:IsHovered()) and toUpper(strTitle) or strTitle
        local crw = self:GetText()

        if (crw ~= targetText) or (curent_panel == toLower(strTitle)) then
            local ntxt = ""
            local will_text = (curent_panel == toLower(strTitle) and not strTitle == 'Роль предателя') and '[ '..toUpper(strTitle)..' ]' or strTitle
            for i = 1, utf8.len(will_text) do
                local char = utf8.sub(will_text, i, i)
                if i <= math.ceil(utf8.len(will_text) * v) then
                    ntxt = ntxt .. toUpper(char)
                else
                    ntxt = ntxt .. char
                end
            end
            if self:GetText() ~= ntxt then
                surface.PlaySound("shitty/tap-resonant.wav")
            end
            self:SetText(ntxt)
        end
        self:SizeToContents()
    end
end

function PANEL:Close()
    self:AlphaTo( 0, 0.1, 0, function() self:Remove() end)
    self:SetKeyboardInputEnabled(false)
    self:SetMouseInputEnabled(false)
end

vgui.Register( "ZMainMenu", PANEL, "ZFrame")

hook.Add("OnPauseMenuShow","OpenMainMenu",function()
    local run = hook.Run("OnShowZCityPause")
    if run != nil then
        return run
    end

    if MainMenu and IsValid(MainMenu) then
        MainMenu:Close()
        MainMenu = nil
        return false
    end

    MainMenu = vgui.Create("ZMainMenu")
    MainMenu:MakePopup()
    return false
end)