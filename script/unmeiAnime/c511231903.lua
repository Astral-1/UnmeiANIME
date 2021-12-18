--Hydradrive Mutation
--Scripted by Aquaburner
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --Attribute Change
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.atttg)
    e2:SetOperation(s.attop)
    c:RegisterEffect(e2)
end
function s.thfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_TRAP+TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function s.setfilter(c)
    return c:IsType(TYPE_TRAP+TYPE_CONTINUOUS) and c:IsSSetable()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.thfilter(chkc) end
    if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false)
        and Duel.IsExistingTarget(s.thfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
     c:CompleteProcedure()
     --Set
     local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_HAND,0,nil)
		 if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			 local sg=g:Select(tp,1,1,nil)
			 if sg:GetFirst() and Duel.SSet(tp,sg) then
         local e1=Effect.CreateEffect(c)
		     e1:SetType(EFFECT_TYPE_SINGLE)
		     e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		     e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		     e1:SetReset(RESET_EVENT+RESETS_STANDARD)
         sg:GetFirst():RegisterEffect(e1)
         end
      end
   end
end
function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup(),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup(),tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local att=tc:GetAttribute()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e1:SetValue(att)
        c:RegisterEffect(e1)
    end
end