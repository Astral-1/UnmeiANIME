--Number's Calling
--Scripted by UNMEI for Itsu RP
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Attach itself to 1 "Number" Xyz monster from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.mattg)
	e2:SetOperation(s.matop)
	e2:SetCondition(aux.exccon)
	e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e2)
end
s.listed_series={0x48}
function s.spfilter(c)
	return c:IsSetCard(0x48) and c:IsType(TYPE_XYZ)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
end

function s.lvfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:HasLevel()
end
function s.fieldlvfilter(c,lv)
	return c:IsFaceup() and c:HasLevel() and not c:IsLevel(lv)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function s.lvtg(e,tp,lv)
	return Duel.IsExistingMatchingCard(s.fieldlvfilter,tp,LOCATION_MZONE,0,1,nil,lv)
end


--local lv=e:GetLabelObject():GetRank()
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabelObject():GetRank()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.lvfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) > 0 and s.lvtg(e,tp,lv) then
		local g2=Duel.GetMatchingGroup(s.fieldlvfilter,tp,LOCATION_MZONE,0,nil,lv)
			for tc in aux.Next(g2) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(lv)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end	
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(id,2))
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e2:SetTargetRange(1,0)
			e2:SetTarget(s.splimit)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			--Clock Lizard check
			aux.addTempLizardCheck(c,tp,s.lizfilter)
		end
	end
end
function s.splimit(e,c)
	return not (c:IsSetCard(0x48) and c:IsType(TYPE_XYZ)) and c:IsLocation(LOCATION_EXTRA)
end
function s.lizfilter(e,c)
	return not (c:IsOriginalSetCard(0x48) and c:IsOriginalType(TYPE_XYZ))
end





--2nd eff
function s.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x48) and c:IsType(TYPE_XYZ)
end
function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.matfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(s.matfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.matfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if(e:GetHandler():IsLocation(LOCATION_GRAVE)) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,c,true)
	end
end
