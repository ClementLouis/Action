-- Action Field - Acrobatic Circus
function c151000001.initial_effect(c)
	if not c151000001.global_check then
		c151000001.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(c151000001.chk)
		Duel.RegisterEffect(ge1,0)
	end
end
c151000001.af=true
c151000001.tableAction = {
95000044,
95000045,
95000046,
95000047,
95000048,
95000143
} 
function c151000001.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,301)
	Duel.CreateToken(1-tp,301)
end
