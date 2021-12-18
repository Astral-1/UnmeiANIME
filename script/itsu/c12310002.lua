--Tech Generation
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
s.listed_series={0x27}
function s.filter(c)
	return (unmei.IsArchetypeListed(c,0x27) or c:IsSetCard(0x27)) and c:IsAbleToHand() 
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
	--Return from hand to deck and add
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
	
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	
	local tc=Duel.CreateToken(tp,12310003)
    Duel.SendtoDeck(tc,tp,SEQ_DECKTOP,REASON_EFFECT)
    Duel.ConfirmCards(tp,tc)
    Duel.ConfirmCards(tp-1,tc)
end
