--大理
--种植牌11

--脚本号
x714067_g_ScriptId = 714067

event_xuanzezhiwu = 713550

--植物产品编号列表
x714067_g_eventList={20104001,20104002,20104005,20104007,20104009,20104012,
			20105001,20105004,20105007,20105012} --植物的编号,不是eventId
--**********************************
--事件交互入口
--**********************************
function x714067_OnDefaultEvent( sceneId, selfId,targetId )
	--PLANTFLAG[1] =0
	--PLANTFLAG[2] =0
	AbilityLevel = QueryHumanAbilityLevel( sceneId, selfId, ABILITY_ZHONGZHI)
	--如果玩家不会种植技能
	if AbilityLevel == 0	then
		BeginEvent(sceneId)
			AddText(sceneId, "你先去学习种植技能吧")
		EndEvent(sceneId)
		DispatchEventList(sceneId, selfId, targetId)
		return
	end
	--如果玩家会种植技能
	if AbilityLevel ~= 0	then
		BeginEvent(sceneId)
			AddText(sceneId, "请选择你要种的植物")
			--通过x714067_g_eventList和scriptglobal中的植物列表对比，并根据玩家种植技能等级来显示相应植物
			for i, eventId in x714067_g_eventList do	--遍历这个稻草人可以种植的植物列表
				for j,g_ZhiWuId in V_ZHONGZHI_ID do		--遍历scriptglobal中的所有植物列表
					if eventId == g_ZhiWuId then
						if AbilityLevel >= V_ZHONGZHI_NEEDLEVEL[j] then --如果玩家种植技能等级>=该植物要求技能等级]
							AddNumText(sceneId, x714067_g_eventList[i], V_ZHONGZHI_NAME[j],6,-1)
							break
						end
					end
				end
			end
		EndEvent(sceneId)
		DispatchEventList(sceneId,selfId,targetId)
	end
end

--**********************************
--事件列表选中一项
--**********************************
function x714067_OnEventRequest( sceneId, selfId, targetId, eventId )
	zhiwuId = eventId
	for i, findId in x714067_g_eventList do
		if zhiwuId == findId then
			CallScriptFunction( 713550, "OnDefaultEvent",sceneId, selfId, targetId, zhiwuId )
			return
		end
	end
end

--**********************************
--接受此NPC的任务（暂时借用任务接口）
--**********************************
function x714067_OnMissionSubmit( sceneId, selfId, targetId, scriptId )
	for i, findId in x714067_g_eventList do
		if scriptId == findId then
			ret = CallScriptFunction( scriptId, "CheckAccept", sceneId, selfId )
			if ret > 0 then
				CallScriptFunction( scriptId, "OnAccept", sceneId, selfId, ABILITY_ZHONGZHI )
				CallScriptFunction( scriptId, "OnDefaultEvent",sceneId, selfId, targetId, ABILITY_ZHONGZHI )
			end
			return
		end
	end
end

--**********************************
--接受此NPC的任务
--**********************************
function x714067_OnMissionAccept( sceneId, selfId, targetId, missionScriptId )
	for i, findId in x714067_g_eventList do
		if missionScriptId == findId then
			ret = CallScriptFunction( missionScriptId, "CheckAccept", sceneId, selfId )
			if ret > 0 then
				CallScriptFunction( missionScriptId, "OnAccept", sceneId, selfId, ABILITY_ZHONGZHI )	
			end
			return
		end
	end
end

