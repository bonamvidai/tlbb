--玩家进入一个 area 时触发
function x400109_OnEnterArea( sceneId, selfId )
	CallScriptFunction((400900), "TransferFunc",sceneId, selfId, 165,80,24)
end

--玩家在一个 area 呆了一段时间没走则定时触发
function x400109_OnTimer( sceneId, selfId )
	-- 毫秒，看在这个 area 停留多久了
	StandingTime = QueryAreaStandingTime( sceneId, selfId )
	-- 5秒后仍未传送
	if StandingTime >= 5000 then
		x400109_OnEnterArea( sceneId, selfId )
		ResetAreaStandingTime( sceneId, selfId, 0 )
	end
end

--玩家离开一个 area 时触发
function x400109_OnLeaveArea( sceneId, selfId )
end
