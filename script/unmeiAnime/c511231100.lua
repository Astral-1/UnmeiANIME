--Neo Space!
--By Astral
--Activate Neo Space (Field Spell Card), from outside the deck, at the beginning of the duel.

local s,id=GetID()
function s.initial_effect(c)
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
    --condition
	return true
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--flips up the skill card
	Duel.RegisterFlagEffect(tp,id,0,0,0)
    Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
    Duel.Hint(HINT_CARD,tp,id)
	--create field spell token
	local tc=Duel.CreateToken(tp,42015635)
	--plays the field spell token
	aux.PlayFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
end