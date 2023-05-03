--WildRuin Raichel
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Tuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.tncon)
	e1:SetOperation(s.tnop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.regtg)
	e2:SetOperation(s.regop)
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
--non-tuner
function s.tncon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	return re:GetHandler():IsSetCard(0x759)
end
function s.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
--search
function s.cfilter(c)
	return c:IsMonster() and c:IsSetCard(0x759) and c:IsAbleToHand()
end
function s.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,3,nil) end
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_DECK,0,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_DECK,0,nil)
	if #g>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(1-tp,1,1,nil)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
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