--天山NPC
--天山童姥
--普通

--**********************************
--事件交互入口
--**********************************
function x017000_OnDefaultEvent( sceneId, selfId,targetId )
	BeginEvent(sceneId)
		AddText(sceneId,"……")
	EndEvent(sceneId)
	DispatchEventList(sceneId,selfId,targetId)
end
