unmei = {}

function unmei.IsArchetypeListed(c,...)
	if not c.listed_series then return false end
	local codes={...}
	for _,code in ipairs(codes) do
		for _,ccode in ipairs(c.listed_series) do
			if code==ccode then return true end
		end
	end
	return false
end

UNMEI_SKILL_COVER  =   300000231

function unmei.SetUnmeiSkillOp(skillcon,skillop,efftype)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if skillop~=nil then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCondition(skillcon)
			e1:SetOperation(skillop)
			Duel.RegisterEffect(e1,e:GetHandlerPlayer())

		end
		Duel.DisableShuffleCheck(true)
		Duel.SendtoDeck(c,tp,-2,REASON_RULE)
		Duel.Hint(HINT_SKILL_COVER,c:GetControler(),UNMEI_SKILL_COVER)
		Duel.Hint(HINT_SKILL,c:GetControler(),c:GetCode())
		if e:GetHandler():IsPreviousLocation(LOCATION_HAND) then 
			Duel.Draw(p,1,REASON_RULE)
		end
		e:Reset()
	end
end

--Proc for Itsu RP (UNMEI) Skills
--flip con: condition to activate the skill (function)
--flipOp: operation related to the skill activation (function)
--efftype: Event to trigger the Skill, default to EVENT_FREE_CHAIN.
function unmei.AddUnmeiSkillProcedure(c,skillcon,skillop,efftype)
	efftype=efftype or EVENT_FREE_CHAIN
	--activate
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(unmei.SetUnmeiSkillOp(skillcon,skillop,efftype))
	c:RegisterEffect(e1)
end