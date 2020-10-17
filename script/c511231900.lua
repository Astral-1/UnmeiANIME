--Covered Hydradrive
--Scripted by Aquaburner
local s,id=GetID()
function s.initial_effect(c)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_BATTLE_DAMAGE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(s.spcon)
  e1:SetTarget(s.sptg)
  e1:SetOperation(s.spop)
  c:RegisterEffect(e1)
  --Battle Protection
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  --No Damage
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetTargetRange(1,0)
  e3:SetCondition(s.procon)
  c:RegisterEffect(e3)
  --Destroy Links
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_DESTROY)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1)
  e4:SetCondition(s.descon)
  e4:SetTarget(s.destg)
  e4:SetOperation(s.desop)
  c:RegisterEffect(e4)
  --Only 1 attack
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_QUICK_O)
  e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e5:SetCode(EVENT_FREE_CHAIN)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(s.condition)
  e5:SetCost(s.cost)
  e5:SetOperation(s.operation)
  c:RegisterEffect(e5)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
      Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
    end
end
function s.procon(e)
    return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x577),0,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.desfilter(c)
    return c:IsSetCard(0x577) and c:IsType(TYPE_LINK)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Destroy(g,REASON_EFFECT)
end
function s.condition(e, tp, eg, ep, ev, re, r, rp)
  return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.operation(e, tp, eg, ep, ev, re, r, rp)
  local c=e:GetHandler()
  --cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
  e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(s.checkop)
  e2:SetReset(RESET_PHASE+PHASE_BATTLE)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function s.atkcon(e)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(id)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
