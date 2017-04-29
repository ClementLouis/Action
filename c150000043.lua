--Miracle Fire
function c150000043.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c150000043.thtg)
	e1:SetOperation(c150000043.thop)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c150000043.handcon)
	c:RegisterEffect(e2)
	if not c150000043.global_check then
		c150000043.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c150000043.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c150000043.handcon(e)
	return tp~=Duel.GetTurnPlayer()
end
function c150000043.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsType(TYPE_SPELL) and rc:IsSetCard(0xac1) then
		rc:RegisterFlagEffect(150000043,RESET_PHASE+PHASE_END,0,0)
	end
end
function c150000043.filter(c)
	return c:GetFlagEffect(150000043)>0 and c:CheckActivateEffect(false,false,false)~=nil
end
function c150000043.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c150000043.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c150000043.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
end
function c150000043.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectMatchingCard(tp,c150000043.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if not tg then return end
	local te=tg:GetFirst():GetActivateEffect()
	local cost=te:GetCost()
	local target=te:GetTarget()
	local operation=te:GetOperation()
	if cost then cost(e,tp,eg,ep,ev,re,r,rp) end
	if target then target(e,tp,eg,ep,ev,re,r,rp) end
	if operation then operation(e,tp,eg,ep,ev,re,r,rp) end
end