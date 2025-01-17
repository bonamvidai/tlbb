--缥缈峰副本....
--乌老大对话脚本....

--脚本号
x402272_g_ScriptId = 402272

--副本逻辑脚本号....
x402272_g_FuBenScriptId = 402263

--战败乌老大对话脚本号....
x402272_g_LossScriptId = 402275

--**********************************
--任务入口函数....
--**********************************
function x402272_OnDefaultEvent( sceneId, selfId, targetId )

	BeginEvent(sceneId)

		AddText( sceneId, "#{PMF_20080521_10}" )
		AddNumText( sceneId, x402272_g_ScriptId, "挑战", 10, 1 )

		--判断当前是否可以挑战李秋水....	
		if 1 == CallScriptFunction( x402272_g_FuBenScriptId, "GetBossBattleFlag", sceneId, "LiQiuShui" ) then
			AddNumText( sceneId, x402272_g_ScriptId, "决战李秋水？", 10, 2 )
		end

	EndEvent(sceneId)
	DispatchEventList(sceneId,selfId,targetId)

end

--**********************************
--事件列表选中一项
--**********************************
function x402272_OnEventRequest( sceneId, selfId, targetId, eventId )

	--如果正在激活BOSS则返回....
	if 1 == CallScriptFunction( x402272_g_FuBenScriptId, "IsPMFTimerRunning", sceneId ) then
		return
	end

	--是不是队长....
	if GetTeamLeader(sceneId,selfId) ~= selfId then
		BeginEvent(sceneId)
			AddText( sceneId, "#{PMF_20080521_07}" )
		EndEvent(sceneId)
		DispatchEventList(sceneId,selfId,targetId)
		return
	end

	--如果正在和别的BOSS战斗则返回....
	local ret, msg = CallScriptFunction( x402272_g_FuBenScriptId, "CheckHaveBOSS", sceneId )
	if 1 == ret then
		BeginEvent(sceneId)
			AddText( sceneId, msg )
		EndEvent(sceneId)
		DispatchMissionTips(sceneId,selfId)
		return
	end

	if GetNumText() == 1 then

		--判断当前是否可以挑战乌老大....	
		if 1 ~= CallScriptFunction( x402272_g_FuBenScriptId, "GetBossBattleFlag", sceneId, "WuLaoDa" ) then
			BeginEvent(sceneId)
				AddText( sceneId, "#{PMF_20080521_11}" )
			EndEvent(sceneId)
			DispatchEventList(sceneId,selfId,targetId)
			return
		end
		--开启缥缈峰计时器来激活自己....
		CallScriptFunction( x402272_g_FuBenScriptId, "OpenPMFTimer", sceneId, 7, x402272_g_ScriptId, -1 ,-1 )

	elseif GetNumText() == 2 then

		--判断当前是否可以挑战李秋水....	
		if 1 ~= CallScriptFunction( x402272_g_FuBenScriptId, "GetBossBattleFlag", sceneId, "LiQiuShui" ) then
			return
		end
		--开启缥缈峰计时器来激活李秋水....
		CallScriptFunction( x402272_g_FuBenScriptId, "OpenPMFTimer", sceneId, 7, x402272_g_LossScriptId, -1 ,-1 )

	end

	BeginUICommand(sceneId)
	EndUICommand(sceneId)
	DispatchUICommand(sceneId,selfId, 1000)

end

--**********************************
--缥缈峰计时器的OnTimer....
--**********************************
function x402272_OnPMFTimer( sceneId, step, data1, data2 )

	if 7 == step then
		CallScriptFunction( x402272_g_FuBenScriptId, "TipAllHuman", sceneId, "战斗5秒钟后开始" )
		return
	end

	if 6 == step then
		CallScriptFunction( x402272_g_FuBenScriptId, "TipAllHuman", sceneId, "战斗4秒钟后开始" )
		return
	end

	if 5 == step then
		CallScriptFunction( x402272_g_FuBenScriptId, "TipAllHuman", sceneId, "战斗3秒钟后开始" )
		return
	end

	if 4 == step then
		CallScriptFunction( x402272_g_FuBenScriptId, "TipAllHuman", sceneId, "战斗2秒钟后开始" )
		return
	end

	if 3 == step then
		CallScriptFunction( x402272_g_FuBenScriptId, "TipAllHuman", sceneId, "战斗1秒钟后开始" )
		return
	end

	if 2 == step then
		--提示战斗开始....
		CallScriptFunction( x402272_g_FuBenScriptId, "TipAllHuman", sceneId, "战斗开始" )
		--删除NPC....
		CallScriptFunction( x402272_g_FuBenScriptId, "DeleteBOSS", sceneId, "WuLaoDa_NPC" )
		return
	end

	if 1 == step then
		--建立BOSS....
		CallScriptFunction( x402272_g_FuBenScriptId, "CreateBOSS", sceneId, "WuLaoDa_BOSS", -1, -1 )
		return
	end

end
