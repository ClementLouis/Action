--Action Card - Evasion
function c150000024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE)
	e1:SetCondition(c150000024.condition)
	e1:SetOperation(c150000024.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c150000024.handcon)
	c:RegisterEffect(e2)
end
function c150000024.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()~=nil
end
function c150000024.handcon(e)
	return tp~=Duel.GetTurnPlayer()
end
function c150000024.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end


