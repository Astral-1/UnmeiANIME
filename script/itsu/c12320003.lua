--Chaos Summoning
--Scripted by UNMEI for Itsu RP
local s,id=GetID()
--START SETUP FUNCTIONS
Duel.LoadScript("unmeiFuncs.lua")

--END SETUP FUNCTIONS

function s.initial_effect(c)
	unmei.AddUnmeiSkillProcedure(c,s.flipcon,s.flipop,EVENT_UNMEI_NOCHAIN)
	--aux.AddVrainsSkillProcedure(c,s.flipcon,s.flipop,EVENT_FREE_CHAIN)
	--aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	if Duel.GetFlagEffect(ep,id)>0 then return end
	return aux.CanActivateSkill(tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--opd check and ask if you want to activate the skill or not
	if Duel.GetFlagEffect(tp,id)>0 or not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	--opd register
	Duel.RegisterFlagEffect(tp,id,0,0,0)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--Check if Skill is negated
	if aux.CheckSkillNegation(e,tp) then return end
	
	
	--Special Summon
	local turn_p=Duel.GetTurnPlayer()
	s.spsummon(e,turn_p,tp)
	s.spsummon(e,1-turn_p,tp)
	
	--sekrit
	--local tc=Duel.CreateToken(tp,12310013)
    --Duel.SendtoDeck(tc,1-tp,SEQ_DECKTOP,REASON_EFFECT)

end
function s.spsummon(e,p,tp)
	if not s.cansummon(e,p) or not Duel.SelectYesNo(p,aux.Stringid(id,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(p,s.spfilter,p,LOCATION_GRAVE,0,1,1,nil,e,p):GetFirst()
	Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEUP_ATTACK)
end

function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function s.cansummon(e,p)
	return Duel.GetLocationCount(p,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,p,LOCATION_GRAVE,0,1,nil,e,p)
end