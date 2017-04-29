-- Action Field Function
function c301.initial_effect(c)
	if not c301.global_check then
		c301.global_check=true
		--register
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCondition(c301.con)
		e1:SetOperation(c301.op)
		Duel.RegisterEffect(e1,0)
	end
end
function c301.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==1
end
function c301.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c) return c.af end,tp,0xff,0xff,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			--Activate	
			local e1=Effect.CreateEffect(tc)	
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ADJUST)
			e1:SetCountLimit(1)
			e1:SetRange(LOCATION_HAND+LOCATION_DECK)
			e1:SetOperation(c301.op2)
			tc:RegisterEffect(e1)
			
			--redirect
			local e2=Effect.CreateEffect(tc)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetOperation(c301.repop)
			tc:RegisterEffect(e2)		
			--unaffectable
			local e5=Effect.CreateEffect(tc)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetRange(LOCATION_SZONE)
			e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e5:SetValue(1)
			tc:RegisterEffect(e5)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_IMMUNE_EFFECT)
			e6:SetValue(c301.ctcon2)
			tc:RegisterEffect(e6)
			--cannot set
			local e7=Effect.CreateEffect(tc)
			e7:SetType(EFFECT_TYPE_FIELD)
			e7:SetCode(EFFECT_CANNOT_SSET)
			e7:SetRange(LOCATION_SZONE)
			e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e7:SetTargetRange(1,0)
			e7:SetTarget(c301.sfilter)
			tc:RegisterEffect(e7)
			-- Add Action Card
			local e8=Effect.CreateEffect(tc)
			e8:SetDescription(aux.Stringid(301,0))
			e8:SetType(EFFECT_TYPE_QUICK_O)
			e8:SetRange(LOCATION_SZONE)
			e8:SetCode(EVENT_FREE_CHAIN)
			e8:SetCondition(c301.condition)
			e8:SetTarget(c301.Acttarget)
			e8:SetOperation(c301.operation)
			tc:RegisterEffect(e8)
			--
			local eb=Effect.CreateEffect(tc)
			eb:SetType(EFFECT_TYPE_FIELD)
			eb:SetCode(EFFECT_CANNOT_TO_DECK)
			eb:SetRange(LOCATION_SZONE)
			eb:SetTargetRange(LOCATION_SZONE,0)
			eb:SetTarget(c301.tgn)
			tc:RegisterEffect(eb)
			local ec=eb:Clone()
			ec:SetCode(EFFECT_CANNOT_TO_HAND)
			tc:RegisterEffect(ec)
			local ed=eb:Clone()
			ed:SetCode(EFFECT_CANNOT_TO_GRAVE)
			tc:RegisterEffect(ed)
			local ee=eb:Clone()
			ee:SetCode(EFFECT_CANNOT_REMOVE)
			tc:RegisterEffect(ee)
			
			
			tc=g:GetNext()
		end
	end
end
function c301.ctcon2(e,re)
	return re:GetHandler()~=e:GetHandler()
end
--speed Duel Filter
function c301.SDfilter(c)
	return c:GetCode()==511004001
end
--vanilla mode filter
function c301.Vfilter(c)
	return c:GetCode()==511004002
end
function c301.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tc2=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)	
	
	--check if number of card >20 if speed duel or >40 if other duel
	if Duel.IsExistingMatchingCard(c301.SDfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_REMOVED,0,1,nil) and Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_DECK,0,nil):GetCount()<20 then
	Duel.Win(1-tp,0x55)
	end
	if Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_DECK,0,e:GetHandler()):GetCount()<40 and not Duel.IsExistingMatchingCard(c301.SDfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_REMOVED,0,1,nil) then
	Duel.Win(1-tp,0x55)
	end
	
	--move to field
	if tc==nil then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		if tc2==nil then
			local token=Duel.CreateToken(tp,c:GetOriginalCode(),nil,nil,nil,nil,nil,nil)		
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(token)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			token:RegisterEffect(e1)
			--redirect
			local e2=Effect.CreateEffect(token)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetOperation(c301.repop)
			token:RegisterEffect(e2)		
			--unaffectable
			local e5=Effect.CreateEffect(token)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetRange(LOCATION_SZONE)
			e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e5:SetValue(1)
			token:RegisterEffect(e5)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_IMMUNE_EFFECT)
			e6:SetValue(c301.ctcon2)
			token:RegisterEffect(e6)
			--cannot set
			local e7=Effect.CreateEffect(token)
			e7:SetType(EFFECT_TYPE_FIELD)
			e7:SetCode(EFFECT_CANNOT_SSET)
			e7:SetRange(LOCATION_SZONE)
			e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e7:SetTargetRange(1,0)
			e7:SetTarget(c301.sfilter)
			token:RegisterEffect(e7)
			-- Add Action Card
			local e8=Effect.CreateEffect(token)
			e8:SetDescription(aux.Stringid(301,0))
			e8:SetType(EFFECT_TYPE_QUICK_O)
			e8:SetRange(LOCATION_SZONE)
			e8:SetCode(EVENT_FREE_CHAIN)
			e8:SetCondition(c301.condition)
			e8:SetTarget(c301.Acttarget)
			e8:SetOperation(c301.operation)
			token:RegisterEffect(e8)
			--
			local eb=Effect.CreateEffect(token)
			eb:SetType(EFFECT_TYPE_FIELD)
			eb:SetCode(EFFECT_CANNOT_TO_DECK)
			eb:SetRange(LOCATION_SZONE)
			eb:SetTargetRange(LOCATION_SZONE,0)
			eb:SetTarget(c301.tgn)
			token:RegisterEffect(eb)
			local ec=eb:Clone()
			ec:SetCode(EFFECT_CANNOT_TO_HAND)
			token:RegisterEffect(ec)
			local ed=eb:Clone()
			ed:SetCode(EFFECT_CANNOT_TO_GRAVE)
			token:RegisterEffect(ed)
			local ee=eb:Clone()
			ee:SetCode(EFFECT_CANNOT_REMOVE)
			token:RegisterEffect(ee)
			Duel.MoveToField(token,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)			
			Duel.SpecialSummonComplete()
		end
		-- add ability Yell when Vanilla mode activated
		-- if Duel.IsExistingMatchingCard(c301.Vfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_REMOVED,0,1,nil) then
			-- c301.tableAction.push(95000200)
		-- end
	else
		Duel.SendtoDeck(e:GetHandler(),nil,-2,REASON_EFFECT)
	end
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end
function c301.sfilter(e,c,tp)
	return c:IsType(TYPE_FIELD) 
end
function c301.tgn(e,c)
	return c==e:GetHandler()
end


-- Add Action Card
function c301.Acttarget(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
if chk==0 then return true end
Duel.Hint(HINT_SELECTMSG,tp,564)
local seed=0
if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then
local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_SZONE,0,nil)
seed = g:GetFirst():GetCode()
else
local g=Duel.GetDecktopGroup(tp,1)
local tc=g:GetFirst()
seed=tc:GetCode()
end

math.randomseed( seed )

ac=math.random(1,#c.tableAction)
e:SetLabel(c.tableAction[ac])
end
function c301.operation(e,tp,eg,ep,ev,re,r,rp)

local rps=Duel.RockPaperScissors()
if rps==0 then
if not Duel.IsExistingMatchingCard(c301.cfilter,tp,LOCATION_HAND,0,1,nil) then	
		local token=Duel.CreateToken(tp,e:GetLabel())
		Duel.SendtoHand(token,nil,REASON_EFFECT)
		local tc=token
		if tc:IsType(TYPE_TRAP) and tc:CheckActivateEffect(false,false,false)~=nil 
		and Duel.GetLocationCount(tp,LOCATION_SZONE) then
		Duel.ConfirmCards(1-p,tc)
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local tg=te:GetTarget()
		local co=te:GetCost()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if bit.band(tpe,TYPE_FIELD)~=0 then
			local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if of then Duel.Destroy(of,REASON_RULE) end
			of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		tc:CreateEffectRelation(te)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
			tc:CancelToGrave(false)
		end
		if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
		if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		tc:ReleaseEffectRelation(te)
		if etc then	
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
	end
end
end

if rps==1 then
 if not Duel.IsExistingMatchingCard(c301.cfilter,1-tp,LOCATION_HAND,0,1,nil) then
		  local token=Duel.CreateToken(1-tp,e:GetLabel())
		Duel.SendtoHand(token,nil,REASON_EFFECT)
		local tc=token
		if tc:IsType(TYPE_TRAP) and tc:CheckActivateEffect(false,false,false)~=nil 
		and Duel.GetLocationCount(tp,LOCATION_SZONE) then
		Duel.ConfirmCards(1-p,tc)
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local tg=te:GetTarget()
		local co=te:GetCost()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if bit.band(tpe,TYPE_FIELD)~=0 then
			local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if of then Duel.Destroy(of,REASON_RULE) end
			of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		tc:CreateEffectRelation(te)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
			tc:CancelToGrave(false)
		end
		if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
		if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		tc:ReleaseEffectRelation(te)
		if etc then	
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
	end
		end

end

local coin=Duel.TossCoin(tp,1)
if coin==1 then
	Duel.RegisterFlagEffect(tp,305,RESET_PHASE+PHASE_END,0,1)
end
end
function c301.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c301.cfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil)
	and Duel.GetFlagEffect(e:GetHandlerPlayer(),305)==0
	and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c301.cfilter(c)
	return c:IsSetCard(0xac1)
end
function c301.repop(e)
	local c=e:GetHandler()
		if c:GetFlagEffect(306)==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetLabelObject(c)
		e1:SetOperation(c301.returnop)
		Duel.RegisterEffect(e1,0)
		c:RegisterFlagEffect(306,0,0,1)
	end
	Duel.SendtoDeck(c,nil,-2,REASON_RULE)
end
function c301.returnop(e)
	local c=e:GetLabelObject()
	local tp=c:GetControler()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if not fc then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	if fc and fc:GetFlagEffect(307)==0 then
	--action card get
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(301,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c301.condition)
	e1:SetTarget(c301.Acttarget2)
	e1:SetLabelObject(c)
	e1:SetOperation(c301.operation)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	fc:RegisterEffect(e1)
	--cannot set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SSET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetTargetRange(1,0)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	e4:SetTarget(c301.sfilter)
	fc:RegisterEffect(e4)
	
	fc:RegisterFlagEffect(307,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c301.Acttarget2(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetLabelObject()
if chk==0 then return true end
Duel.Hint(HINT_SELECTMSG,tp,564)
local seed=0
if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then
local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_SZONE,0,nil)
seed = g:GetFirst():GetCode()
else
local g=Duel.GetDecktopGroup(tp,1)
local tc=g:GetFirst()
seed=tc:GetCode()
end

math.randomseed( seed )

ac=math.random(1,#c.tableAction)
e:SetLabel(c.tableAction[ac])
end