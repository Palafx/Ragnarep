--Wild Ruin Leika
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x759),2,2)
	c:EnableReviveLimit()
	--Special Summon 1 "Sunseed Genius Loci" from your GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.indtg)
	e2:SetValue(s.indesval)
	c:RegisterEffect(e2)
	-- Cannot be destroyed by battle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetValue(s.val)
	e3:SetCondition(s.repcon)
	c:RegisterEffect(e3)
end
s.listed_series={0x759}
--SpecialSummon
function s.filter(c,e,tp)
	return c:IsSetCard(0x759) and (not c:IsAttribute(e:GetHandler():GetAttribute())) and c:IsCanBeSpecialSummoned(e,100,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,100,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)
	end
end
--indestructable
function s.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function s.indesval(e,re)
	return re:IsActiveType(TYPE_SPELL)
end
--cannot be destroyed
function s.val(e,c)
	return not c:IsAttribute(e:GetHandler():GetAttribute())
end
function s.dirfilter1(c)
	return c:IsFaceup() and c:IsCode(5579020)
end
function s.repcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.dirfilter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end