--传入战场的Npc
--普通

--脚本号
x125001_g_scriptId = 125001

--所拥有的事件ID列表
x125001_g_eventList={001232}

--**********************************
--事件交互入口
--**********************************
function x125001_OnDefaultEvent( sceneId, selfId, targetId )
	BeginEvent(sceneId)
		AddText(sceneId,"  想要进入战场吗？你准备好了没有？")
		for i, eventId in x125001_g_eventList do
			CallScriptFunction( eventId, "OnEnumerate",sceneId, selfId, targetId )
		end
	EndEvent(sceneId)
	DispatchEventList(sceneId, selfId, targetId)
end

--**********************************
--事件列表选中一项
--**********************************
function x125001_OnEventRequest( sceneId, selfId, targetId, eventId )
	for i, findId in x125001_g_eventList do
		if eventId == findId then
			CallScriptFunction( eventId, "OnDefaultEvent",sceneId, selfId, targetId )
		end
	end
end

