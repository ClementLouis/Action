--Action Card - Sound Rebound
function c150000064.initial_effect(c)
	--negation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c150000064.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c150000064.handcon)
	c:RegisterEffect(e2)
end
function c150000064.handcon(e)
	return tp~=Duel.GetTurnPlayer()
end
function c150000064.activate(e,tp,eg,ep,ev,re,r,rp)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	--e1:SetRange(LOCATION_SZONE)
	if Duel.SelectOption(tp,aux.Stringid(150000064,0),aux.Stringid(150000064,1))==0 then
		e1:SetCondition(c150000064.negcon1)
	else
		e1:SetCondition(c150000064.negcon2)
	end
	e1:SetTarget(c150000064.negtg)
	e1:SetOperation(c150000064.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c150000064.negcon1(e,tp,eg,ep,ev,re,r,rp)
	c150000064.negcon(e,tp,eg,ep,ev,re,r,rp,CATEGORY_DESTROY)
end
function c150000064.negcon2(e,tp,eg,ep,ev,re,r,rp)
	c150000064.negcon(e,tp,eg,ep,ev,re,r,rp,CATEGORY_NEGATE)
end
function c150000064.negcon(e,tp,eg,ep,ev,re,r,rp,cat)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,cat)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsType,nil,TYPE_SPELL)-tg:GetCount()>0
end
function c150000064.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c150000064.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end