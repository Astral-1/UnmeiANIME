--Archfiends Contract with the Abyss
--Scripted by UNMEI for Itsu RP

local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.AddProcGreater(c,s.ritualfil,nil,nil,s.extrafil)
	if not GhostBelleTable then GhostBelleTable={} end
	table.insert(GhostBelleTable,e1)
end
s.fit_monster={95825679} --lmao, lol even
s.listed_names={95825679}
function s.ritualfil(c)
	return c:IsCode(95825679) and c:IsRitualMonster()
end
function s.mfilter(c)
	return not Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) and c:HasLevel() and c:IsAbleToRemove()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,0,nil)
end
