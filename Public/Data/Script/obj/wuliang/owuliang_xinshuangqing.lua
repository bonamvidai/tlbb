--辛双清

--脚本号
x006006_g_scriptId = 006006

--所拥有的事件ID列表
x006006_g_eventList={}--210604,210605,210607,210609}  --210608	

--**********************************
--事件列表
--**********************************
function x006006_UpdateEventList( sceneId, selfId,targetId )
	BeginEvent(sceneId)
	AddText(sceneId,"#{OBJ_wuliang_0004}")
	for i, eventId in x006006_g_eventList do
		CallScriptFunction( eventId, "OnEnumerate",sceneId, selfId, targetId )
		
	end
	EndEvent(sceneId)
	DispatchEventList(sceneId,selfId,targetId)
end

--**********************************
--事件交互入口
--**********************************
function x006006_OnDefaultEvent( sceneId, selfId,targetId )
	x006006_UpdateEventList( sceneId, selfId, targetId )
end

--**********************************
--事件列表选中一项
--**********************************
function x006006_OnEventRequest( sceneId, selfId, targetId, eventId )
	for i, findId in x006006_g_eventList do
		if eventId == findId then
			CallScriptFunction( eventId, "OnDefaultEvent",sceneId, selfId, targetId )
			return
		end
	end
end

--**********************************
--接受此NPC的任务
--**********************************
function x006006_OnMissionAccept( sceneId, selfId, targetId, missionScriptId )
	for i, findId in x006006_g_eventList do
		if missionScriptId == findId then
			ret = CallScriptFunction( missionScriptId, "CheckAccept", sceneId, selfId )
			if ret > 0 then
				CallScriptFunction( missionScriptId, "OnAccept", sceneId, selfId )
			end
			return
		end
	end
end

--**********************************
--拒绝此NPC的任务
--**********************************
function x006006_OnMissionRefuse( sceneId, selfId, targetId, missionScriptId )
	--拒绝之后，要返回NPC的事件列表
	for i, findId in x006006_g_eventList do
		if missionScriptId == findId then
			x006006_UpdateEventList( sceneId, selfId, targetId )
			return
		end
	end
end

--**********************************
--继续（已经接了任务）
--**********************************
function x006006_OnMissionContinue( sceneId, selfId, targetId, missionScriptId )
	for i, findId in x006006_g_eventList do
		if missionScriptId == findId then
			CallScriptFunction( missionScriptId, "OnContinue", sceneId, selfId, targetId )
			return
		end
	end
end

--**********************************
--提交已做完的任务
--**********************************
function x006006_OnMissionSubmit( sceneId, selfId, targetId, missionScriptId, selectRadioId )
	for i, findId in x006006_g_eventList do
		if missionScriptId == findId then
			CallScriptFunction( missionScriptId, "OnSubmit", sceneId, selfId, targetId, selectRadioId )
			return
		end
	end
end

--**********************************
--死亡事件
--**********************************
function x006006_OnDie( sceneId, selfId, killerId )
end
