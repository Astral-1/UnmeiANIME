--Crimson Dragon, the Duel Dragon
--Raj: this card is cursed
--Astral: Cry about it
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),3,3)
	c:EnableReviveLimit()
	--cannot be targeted/destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.tgcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(s.inval)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
	--add field spell
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.addtarget)
	e4:SetOperation(s.activate)
	e4:SetCondition(s.addcon)
	e4:SetCountLimit(1,{id,1})
	c:RegisterEffect(e4)
	--PROTECC
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_SZONE,0)
	e5:SetTarget(s.stindtg)
	e5:SetCondition(s.stcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function s.inval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function s.tgcon(e)
	return #(e:GetHandler():GetLinkedGroup():Filter(Card.IsType,nil,TYPE_MONSTER))>0
end
--SPECIAL SUMMON FROM GY
function s.spfilter(c,e,tp)
	return (c:IsSetCard(0xc2) or ((c:GetLevel()==7 or c:GetLevel()==8) and c:IsRace(RACE_DRAGON)))
		and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- Cannot Special Summon from the Extra Deck, except Synchro Monsters
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,2))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetTargetRange(1,0)
	e0:SetTarget(s.splimit)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
	end
	Duel.SpecialSummonComplete()
end

function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
--END SPECIAL SUMMON

--ADD FIELD SPELL (CONTROL DRAGON)
function s.addfilter(c)
	return (c:IsCode(01003840) or c:IsCode(84335863) or c:IsCode(56074358)) and c:IsAbleToHand()
	--return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function s.addfilter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO)
end
function s.addcon(e,tp,eg,ep,ev,re,r,rp)
	--return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsType,TYPE_SYNCHRO),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
	return Duel.IsExistingMatchingCard(s.addfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.addtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
----

--SPELL-TRAP PROTECTION
function s.stfilter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO)
end
function s.stcon(e,tp,eg,ep,ev,re,r,rp)
	--return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsType,TYPE_SYNCHRO),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
	return Duel.IsExistingMatchingCard(s.stfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.stindtg(e,c)
	return true
end