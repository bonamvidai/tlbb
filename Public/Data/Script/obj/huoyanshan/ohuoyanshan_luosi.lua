--火焰山NPC
--洛斯
--任务

x042506_g_ScriptId	= 042506

--**********************************
--事件交互入口
--**********************************
function x042506_OnDefaultEvent( sceneId, selfId,targetId )
	BeginEvent( sceneId )
		AddText( sceneId, "#{HYS_20071224_15}" )
		
	EndEvent( sceneId )
	DispatchEventList( sceneId, selfId, targetId )
end
