--石林 郑圆

--脚本号
x026004_g_scriptId = 026004

--所拥有的事件ID列表
x026004_g_eventList={212124}--211705

--**********************************
--事件列表
--**********************************
function x026004_UpdateEventList( sceneId, selfId,targetId )
	BeginEvent(sceneId)
	local  PlayerName=GetName(sceneId,selfId)	
	AddText(sceneId,"不管发生什么事情，我都不会相信我相公会变为偃师，他是我最爱的人，也是我这个世界上唯一的亲人，他一定是有苦衷的，一定的。都是那些该死的偃师的错，都是他们的错！")
	for i, eventId in x026004_g_eventList do
		CallScriptFunction( eventId, "OnEnumerate",sceneId, selfId, targetId )
	end
	EndEvent(sceneId)
	DispatchEventList(sceneId,selfId,targetId)
end

--**********************************
--事件交互入口
--**********************************
function x026004_OnDefaultEvent( sceneId, selfId,targetId )
	x026004_UpdateEventList( sceneId, selfId, targetId )
end

--**********************************
--事件列表选中一项
--**********************************
function x026004_OnEventRequest( sceneId, selfId, targetId, eventId )
	for i, findId in x026004_g_eventList do
		if eventId == findId then
			CallScriptFunction( eventId, "OnDefaultEvent",sceneId, selfId, targetId )
			return
		end
	end
end

--**********************************
--接受此NPC的任务
--**********************************
function x026004_OnMissionAccept( sceneId, selfId, targetId, missionScriptId )
	for i, findId in x026004_g_eventList do
		if missionScriptId == findId then
			ret = CallScriptFunction( missionScriptId, "CheckAccept", sceneId, selfId )
			if ret > 0 then
				CallScriptFunction( missionScriptId, "OnAccept", sceneId, selfId, targetId )
			end
			return
		end
	end
end

--**********************************
--拒绝此NPC的任务
--**********************************
function x026004_OnMissionRefuse( sceneId, selfId, targetId, missionScriptId )
	--拒绝之后，要返回NPC的事件列表
	for i, findId in x026004_g_eventList do
		if missionScriptId == findId then
			x026004_UpdateEventList( sceneId, selfId, targetId )
			return
		end
	end
end

--**********************************
--继续（已经接了任务）
--**********************************
function x026004_OnMissionContinue( sceneId, selfId, targetId, missionScriptId )
	for i, findId in x026004_g_eventList do
		if missionScriptId == findId then
			CallScriptFunction( missionScriptId, "OnContinue", sceneId, selfId, targetId )
			return
		end
	end
end

--**********************************
--提交已做完的任务
--**********************************
function x026004_OnMissionSubmit( sceneId, selfId, targetId, missionScriptId, selectRadioId )
	for i, findId in x026004_g_eventList do
		if missionScriptId == findId then
			CallScriptFunction( missionScriptId, "OnSubmit", sceneId, selfId, targetId, selectRadioId )
			return
		end
	end
end

--**********************************
--死亡事件
--**********************************
function x026004_OnDie( sceneId, selfId, killerId )
end
