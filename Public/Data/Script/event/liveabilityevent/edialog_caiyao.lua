--对话事件 npc白颖明

--脚本号
x713608_g_ScriptId = 713608

--**********************************
--任务入口函数
--**********************************
function x713608_OnDefaultEvent( sceneId, selfId, targetId)
	dialog = "#{event_liveabilityevent_0008}"
		BeginEvent(sceneId)
		AddText(sceneId, dialog)
		EndEvent(sceneId)
		DispatchEventList(sceneId, selfId, targetId)
end

--**********************************
--列举事件
--**********************************
function x713608_OnEnumerate( sceneId, selfId, targetId )
		AddNumText(sceneId,x713608_g_ScriptId,"我想了解采药",11,-1)
end

--**********************************
--检测接受条件
--**********************************
function x713608_CheckAccept( sceneId, selfId )
end

--**********************************
--接受
--**********************************
function x713608_OnAccept( sceneId, selfId, AbilityId )
end
