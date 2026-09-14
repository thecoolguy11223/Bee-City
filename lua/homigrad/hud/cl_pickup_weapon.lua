--[[local pickhistory = {}
local typeState = {}

function addnotification(text)
    local id = tostring(CurTime().."_"..math.random(0,1000))
    local tbl = {
        Text = text,
        Time = CurTime(),
        itemid = id
    }
    table.insert(pickhistory,tbl)
    typeState[id] = {t = 0, len = #text, smoothW = 0}
end
hook.Add("HUDItemPickedUp", "HomigradPickup_Item", function(itemName)
    if not IsValid(LocalPlayer()) or not LocalPlayer():Alive() then return end
    local name = language.GetPhrase(itemName)
    addnotification(name)
    return true
end)

hook.Add("HUDAmmoPickedUp", "HomigradPickup_Ammo", function(itemName, amount)
    if not IsValid(LocalPlayer()) or not LocalPlayer():Alive() then return end
    local name = language.GetPhrase(itemName)
    addnotification(amount .. " " .. name)
    return true
end)

hook.Add("HUDWeaponPickedUp", "HomigradPickup_Weapon", function(wep)
    --print("HUY")
    if not IsValid(LocalPlayer()) or not LocalPlayer():Alive() then return end
    if not IsValid(wep) then return end
    if wep:GetClass() == "weapon_hands_sh" then return end
    local name = language.GetPhrase(wep:GetPrintName())
    addnotification(name)
    return true
end)
local hudstuff = {
    textclr = Color(255,255,255),
    textfont = "HomigradMedium",
    bgcolor = Color(50,50,50),
    bgoutlineclr = Color(255,180,85),
    maxBoxWidth = ScreenScale(200)
}
hook.Add("HUDPaint","notifypickup",function ()
    if table.IsEmpty(pickhistory) then return end
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() then return end
    if ply.organism and ply.organism.otrub then return end
    local sw, sh = ScrW(), ScrH()
    local startX = sw - ScreenScale(20) 
    local startY = sh * 0.4 
    local padding = ScreenScale(6) 
    local spacing = ScreenScale(4)
    local currentY = startY
    for i,item in pairs(pickhistory) do
        local elapsed = CurTime() - item.Time
        local endtime = 2
        local alpha = 255
        local text = "+"..item.Text
        local font = hudstuff.textfont
        local current_bg = hudstuff.bgcolor
        local current_outline = hudstuff.bgoutlineclr
        local clr = hudstuff.textclr
        local mbw = hudstuff.maxBoxWidth
        local tw, th = surface.GetTextSize(text)
        local targetWidth = tw + (padding * 2)
        if targetWidth > mbw then targetWidth = mbw end
        local s = typeState[item.itemid]
        if s then
            s.smoothW = Lerp(FrameTime() * 10, s.smoothW or 0, targetWidth)
        end
        local boxWidth = s and s.smoothW or targetWidth
        local boxHeight = th + padding
        local drawX = startX - boxWidth
        local drawY = currentY
        draw.RoundedBox(0, drawX, drawY, boxWidth, boxHeight, current_bg)
        surface.SetDrawColor(current_outline)
        surface.DrawOutlinedRect(drawX, drawY, boxWidth, boxHeight, 1)
        render.SetScissorRect(drawX, drawY, drawX + boxWidth, drawY + boxHeight, true)
        draw.DrawText(text, font, drawX + boxWidth/2, drawY + boxHeight/2, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        render.SetScissorRect(0, 0, 0, 0, false)
        
        currentY = currentY + boxHeight + spacing
    end
end)]]