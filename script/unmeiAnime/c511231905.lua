--Rousing Hydradrive Monarch
--By UNMEI
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x577)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.matfilter,4,4)
	--add counters
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(id,0))
    e0:SetCategory(CATEGORY_COUNTER)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetProperty(EFFECT_FLAG_DELAY)
    e0:SetCondition(s.ctcon)
    e0:SetOperation(s.ctop)
    c:RegisterEffect(e0)
	
	--extra attributes
  	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e1)
  	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e3)
	
	--position changing
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SET_POSITION)
    e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.postg)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetValue(POS_FACEUP_ATTACK)
    c:RegisterEffect(e4)
	--effect disabling
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(s.distarget)
	c:RegisterEffect(e5)
	--diceroll to send to GY
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_DICE)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
	e6:SetCost(s.rollcost)
    e6:SetOperation(s.rollop)
    c:RegisterEffect(e6)
	
end
s.listed_series={0x577}
s.roll_dice=true

function s.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_LINK,scard,sumtype,tp) and c:IsSetCard(0x577,scard,sumtype,tp)
end

function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        c:AddCounter(0x577,4)
    end
end
function s.postg(e,c)
	return c:IsFaceup() and c:IsAttribute(e:GetHandler():GetAttribute())
end
function s.distarget(e,c)
	return c:IsAttribute(e:GetHandler():GetAttribute()) and c:IsType(TYPE_EFFECT)
end

function s.rollcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x577,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x577,1,REASON_COST)
end

function s.sendfilter(c,e)
	return c:IsAttribute(e:GetHandler():GetAttribute()) and c:IsFaceup()
end
function s.sgfilter(c,p)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(p)
end
function s.rollop(e,tp,eg,ep,ev,re,r,rp)
	--e:GetHandler():RemoveCounter(ep,0x577,1,REASON_EFFECT)
	local e = e
    local d=Duel.TossDice(tp,1)
	--[[
	if d == 1 or d == 2 or d == 3 or d ==4 or d ==5 or d ==6 then
		--local sg=Duel.GetMatchingGroup(s.sendfilter,1-tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
		local sg=Duel.GetMatchingGroup(s.sendfilter,1-tp,LOCATION_MZONE,nil,nil,e)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		--local ndmg = sg.GetCount(sg)
		local ndmg = sg:FilterCount(s.sgfilter,nil,1-tp)
		Duel.Damage(1-tp,ndmg*500,REASON_EFFECT)
	end
	]]--
    if d==1 then
		local sg=Duel.GetMatchingGroup(Card.IsAttribute,1-tp,LOCATION_MZONE,nil,nil,ATTRIBUTE_EARTH)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local ndmg = sg:FilterCount(s.sgfilter,nil,1-tp)
		Duel.Damage(1-tp,ndmg*500,REASON_EFFECT)
    elseif d==2 then
		local sg=Duel.GetMatchingGroup(Card.IsAttribute,1-tp,LOCATION_MZONE,nil,nil,ATTRIBUTE_WATER)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local ndmg = sg:FilterCount(s.sgfilter,nil,1-tp)
		Duel.Damage(1-tp,ndmg*500,REASON_EFFECT)
	elseif d==3 then
		local sg=Duel.GetMatchingGroup(Card.IsAttribute,1-tp,LOCATION_MZONE,nil,nil,ATTRIBUTE_FIRE)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local ndmg = sg:FilterCount(s.sgfilter,nil,1-tp)
		Duel.Damage(1-tp,ndmg*500,REASON_EFFECT)
	elseif d==4 then
		local sg=Duel.GetMatchingGroup(Card.IsAttribute,1-tp,LOCATION_MZONE,nil,nil,ATTRIBUTE_WIND)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local ndmg = sg:FilterCount(s.sgfilter,nil,1-tp)
		Duel.Damage(1-tp,ndmg*500,REASON_EFFECT)
	elseif d==5 then
		local sg=Duel.GetMatchingGroup(Card.IsAttribute,1-tp,LOCATION_MZONE,nil,nil,ATTRIBUTE_LIGHT)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local ndmg = sg:FilterCount(s.sgfilter,nil,1-tp)
		Duel.Damage(1-tp,ndmg*500,REASON_EFFECT)
    else
		local sg=Duel.GetMatchingGroup(Card.IsAttribute,1-tp,LOCATION_MZONE,nil,nil,ATTRIBUTE_DARK)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local ndmg = sg:FilterCount(s.sgfilter,nil,1-tp)
		Duel.Damage(1-tp,ndmg*500,REASON_EFFECT)
    end

end