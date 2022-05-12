--Alien's Corruption
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
s.listed_series={0xc}
function s.addfilter1(c)
	return aux.CanPlaceCounter(c,COUNTER_A) and c:IsAbleToHand() 
end
function s.addfilter2(c)
	return c:IsSetCard(0xc) and c:IsAbleToHand() 
end
function s.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_REPTILE) and c:IsAbleToGrave()
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
	--Mill from Deck
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	
	--actually add
	
	local g1=Duel.GetMatchingGroup(s.addfilter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(s.addfilter2,tp,LOCATION_DECK,0,nil)
	if #g1>0 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
end
