-- ZA UNMEI SKILL
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,2,false,nil,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.CanActivateSkill(tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local c=e:GetHandler()
	
	--All effects LMAO
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.con)
	e1:SetOperation(s.op)
	Duel.RegisterEffect(e1,tp)
end


function s.thfilter(c)
	return c:IsAbleToHand()
end
function s.ssfilter(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_MONSTER)
end
function s.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.mvfilter(c)
	return c:IsFaceup()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() and Duel.GetTurnPlayer()==tp
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=1 
	local g2=1
	local g3=1
	local g4=1
	local opt=0
	local tkn = 0
	if g1 and g2 and g3 and g4 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,3),aux.Stringid(id,4),aux.Stringid(id,5),aux.Stringid(id,8))
	else return end
	-- ss token
	if opt==0 then
		tkn=Duel.SelectOption(tp,aux.Stringid(id,6),aux.Stringid(id,7))
			if tkn==0 then
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0xfe,TYPES_TOKEN,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) then
					local t1=Duel.CreateToken(tp,id+1)
					Duel.SpecialSummonStep(t1,0,tp,tp,false,false,POS_FACEUP)
					Duel.SpecialSummonComplete()
				end
			else
				if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0xfe,TYPES_TOKEN,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,1-tp) then
				local t2=Duel.CreateToken(tp,id+1)
				Duel.SpecialSummonStep(t2,0,tp,1-tp,false,false,POS_FACEUP)
				Duel.SpecialSummonComplete()
				end
			end
	-- search any card
	elseif opt ==1 then
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			end
	--ss any monster
	elseif opt ==2 then
		local ss1 =Duel.GetMatchingGroup(s.ssfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
		if #ss1>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=ss1:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg1,0,tp,tp,true,false,POS_FACEUP)
		end
	--activate traps
	elseif opt ==3 then
		local c=e:GetHandler()
	    local eTrp=Effect.CreateEffect(c)
		eTrp:SetType(EFFECT_TYPE_FIELD)
		eTrp:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		eTrp:SetTargetRange(LOCATION_HAND,0)
		eTrp:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(eTrp,tp)
	elseif opt ==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	elseif opt ==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg2=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if #tg2>0 then
			Duel.SendtoGrave(tg2,REASON_EFFECT)
		end
	elseif opt ==6 then
		Duel.PayLPCost(tp,1000)
		local td = Duel.SelectTarget(tp,s.mvfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if td and td:IsFaceup() and td:IsRelateToEffect(e) and td:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.MoveSequence(td,math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0),2))
			if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
        end
	elseif opt ==7 then
		Duel.PayLPCost(tp,2000)
	elseif opt ==8 then
		Duel.PayLPCost(tp,3000)
	elseif opt ==9 then
		Duel.PayLPCost(tp,4000)
	else end
end
