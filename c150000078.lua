--Action Card - Sky Fall
function c150000078.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c150000078.target)
	e1:SetOperation(c150000078.activate)
	c:RegisterEffect(e1)
end
function c150000078.filter(c)
	return c:IsSetCard(0xac1) and c:IsFaceup()
end
function c150000078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c150000078.filter,tp,0,LOCATION_SZONE+HAND,1,nil) end
	local sg=Duel.GetMatchingGroup(c150000078.filter,tp,0,LOCATION_SZONE+HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c150000078.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c150000078.filter,tp,0,LOCATION_SZONE+HAND,nil)
	if Duel.Destroy(sg,REASON_EFFECT) then
		Duel.Damage(1-tp,300,REASON_EFFECT)
	end
end
