-- 寻找矿石任务
--MisDescBegin
-- 脚本号
x600003_g_ScriptId = 600003

--任务号
x600003_g_MissionId = 1105

--任务目标npc
x600003_g_Name = "马应雄"

--任务归类
x600003_g_MissionKind = 50

--任务等级
x600003_g_MissionLevel = 10000

--是否是精英任务
x600003_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
x600003_g_IsMissionOkFail = 0							-- 任务完成标记

--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x600003_g_MissionName = "工程任务"
x600003_g_MissionInfo = ""													--任务描述
x600003_g_MissionTarget = "    寻找%i，交给帮会城市的马应雄 ( 65, 55 )。"	--任务目标
x600003_g_ContinueInfo = "    你的任务还没有完成么？"						--未完成任务的npc对话
x600003_g_SubmitInfo = "    事情进展得如何？"								--完成未提交时的npc对话
x600003_g_MissionComplete = "    干得不错，甚好甚好。"						--完成任务npc说话的话

x600003_g_Parameter_Item_IDRandom = { { id = 5, num = 1 } }

x600003_g_StrForePart = 5
x600003_g_Offset = 6														-- Suppose to 6, 表里第几个物品列的偏移量

x600003_g_MissionRound = 38

-- 通用城市任务脚本
x600003_g_CityMissionScript = 600001
x600003_g_EngineeringScript = 600002

--任务奖励

--MisDescEnd
--**********************************
--任务入口函数
--**********************************
function x600003_OnDefaultEvent( sceneId, selfId, targetId )	--点击该任务后执行此脚本
	if GetName( sceneId, targetId ) ~= x600003_g_Name then		--判断该npc是否是对应任务的npc
		return
	end

	--如果已接此任务
	if IsHaveMission( sceneId, selfId, x600003_g_MissionId ) > 0 then
		local bDone = x600003_CheckSubmit( sceneId, selfId )
		local strText

		if bDone == 1 then
			strText = x600003_g_SubmitInfo
		else
			strText = x600003_g_ContinueInfo
		end

		--发送任务需求的信息
		BeginEvent( sceneId )
			AddText( sceneId, x600003_g_MissionName )
			AddText( sceneId, strText )
		EndEvent( )
		DispatchMissionDemandInfo( sceneId, selfId, targetId, x600003_g_ScriptId, x600003_g_MissionId, bDone )
	--满足任务接收条件
	elseif x600003_CheckAccept( sceneId, selfId ) > 0 then
		local nTemp = CallScriptFunction( x600003_g_CityMissionScript, "CanDoMisToDay", sceneId, selfId )
		if nTemp == 1   then
			x600003_OnAccept( sceneId, selfId, targetId )
		end
	end
end

--**********************************
--列举事件
--**********************************
function x600003_OnEnumerate( sceneId, selfId, targetId )
	if GetName( sceneId, targetId ) ~= x600003_g_Name then		--判断该npc是否是对应任务的npc
		return
	end

   --如果已接此任务
	if IsHaveMission( sceneId, selfId, x600003_g_MissionId ) > 0 then
		AddNumText( sceneId, x600003_g_ScriptId, x600003_g_MissionName,3,-1 )
	end
end

--**********************************
--检测接受条件
--**********************************
function x600003_CheckAccept( sceneId, selfId )
	local ret = CallScriptFunction( x600003_g_EngineeringScript, "CheckAccept", sceneId, selfId )
	return ret
end

--**********************************
--根据相应建筑等级得到对应MissionItem_HashTable.txt中的单元索引
--**********************************
function x600003_GetMissionItemIndex( sceneId, selfId )
	local nBuildingLevel = CityGetBuildingLevel( sceneId, selfId, sceneId, CITY_BUILDING_DUANTAI )
	local nPos

	if nBuildingLevel == 0 then								-- 1
		nPos = x600003_g_Offset
	elseif nBuildingLevel == 1 then							-- 2
		nPos = x600003_g_Offset + 1
	elseif nBuildingLevel == 2 then							-- 3
		nPos = x600003_g_Offset + 2
	elseif nBuildingLevel == 3 then							-- 4
		nPos = x600003_g_Offset + 3
	else													-- 5
		nPos = 157
	end

	return nPos
end

--**********************************
--接受
--**********************************
function x600003_OnAccept( sceneId, selfId, targetId )
	if GetName( sceneId, targetId ) ~= x600003_g_Name then		--判断该npc是否是对应任务的npc
		return
	end

	if GetLevel( sceneId, selfId ) < 20 then
		CallScriptFunction( x600003_g_CityMissionScript, "NotifyFailTips", sceneId, selfId, "等级不够" )
		return
	end

	--加入任务到玩家列表
	AddMission( sceneId, selfId, x600003_g_MissionId, x600003_g_ScriptId, 0, 0, 1 )	-- kill、area、item
	if IsHaveMission( sceneId, selfId, x600003_g_MissionId ) <= 0 then
		return
	end

	CallScriptFunction( x600003_g_EngineeringScript, "OnAccept", sceneId, selfId, targetId, x600003_g_ScriptId )

	local misIndex = GetMissionIndexByID( sceneId, selfId, x600003_g_MissionId )
	local nitemId, strItemName, _ = GetOneMissionItem( x600003_GetMissionItemIndex( sceneId, selfId ) )

	SetMissionByIndex( sceneId, selfId, misIndex, x600003_g_StrForePart, nitemId )

	--显示内容告诉玩家已经接受了任务
	BeginEvent( sceneId )
		local missionInfo
		if random(2) == 1 then
			missionInfo = format( "    本城正在研究各种矿石，现在还缺少#Y%s#W，希望你能帮我找来。", strItemName )
		else
			missionInfo = format( "    听说#Y%s#W坚硬无比，我们需要知道原因，劳烦你帮我寻来，定有酬谢。", strItemName )
		end

		AddText( sceneId, missionInfo )
		AddText( sceneId, "#r    你接受了任务：" .. x600003_g_MissionName )
	EndEvent( sceneId )
	DispatchEventList( sceneId, selfId, targetId )

	-- 检测身上是否已有此物品
	if LuaFnGetAvailableItemCount( sceneId, selfId, nitemId ) > 0 then
		x600003_OnItemChanged( sceneId, selfId, nitemId )
	end
end

--**********************************
--放弃
--**********************************
function x600003_OnAbandon( sceneId, selfId )
	--删除玩家任务列表中对应的任务
	CallScriptFunction( x600003_g_EngineeringScript, "OnAbandon", sceneId, selfId )
end

--**********************************
--继续
--**********************************
function x600003_OnContinue( sceneId, selfId, targetId )
	BeginEvent( sceneId )
		AddText( sceneId, x600003_g_MissionName )
		AddText( sceneId, x600003_g_MissionComplete )
	EndEvent( )
	DispatchMissionContinueInfo( sceneId, selfId, targetId, x600003_g_ScriptId, x600003_g_MissionId )
end

--**********************************
--检测是否可以提交
--**********************************
function x600003_CheckSubmit( sceneId, selfId )
	local ret = CallScriptFunction( x600003_g_EngineeringScript, "CheckSubmit", sceneId, selfId )

	if ret == 1 then
		local misIndex = GetMissionIndexByID( sceneId, selfId, x600003_g_MissionId )
		local demandItemId = GetMissionParam( sceneId, selfId, misIndex, x600003_g_StrForePart )
		local nItemNum = LuaFnGetAvailableItemCount( sceneId, selfId, demandItemId )

		if nItemNum < 1 then
			ret = 0
		end
	end

	return ret
end

--**********************************
--提交
--**********************************
function x600003_OnSubmit( sceneId, selfId, targetId, selectRadioId )
	if GetName( sceneId, targetId ) ~= x600003_g_Name then		--判断该npc是否是对应任务的npc
		return
	end

	if x600003_CheckSubmit( sceneId, selfId ) == 1 then
		-- 扣东西
		local misIndex = GetMissionIndexByID( sceneId, selfId, x600003_g_MissionId )
		local demandItemId = GetMissionParam( sceneId, selfId, misIndex, x600003_g_StrForePart )
		local nItemNum = LuaFnGetAvailableItemCount( sceneId, selfId, demandItemId )

		if nItemNum > 0 then
			local ret = LuaFnDelAvailableItem( sceneId, selfId, demandItemId, 1 )
			if ret < 1 then
				return
			end
		else											-- 只作为容错，理论上不可能发生
			SetMissionByIndex( sceneId, selfId, misIndex, x600003_g_IsMissionOkFail, 0 )
			return
		end

		CallScriptFunction( x600003_g_EngineeringScript, "OnSubmit", sceneId, selfId, targetId, selectRadioId )
	end
end

--**********************************
--杀死怪物或玩家
--**********************************
function x600003_OnKillObject( sceneId, selfId, objdataId, objId )	--参数意思：场景号、玩家objId、怪物表位置号、怪物objId
end

--**********************************
--进入区域事件
--**********************************
function x600003_OnEnterArea( sceneId, selfId, zoneId )
end

--**********************************
--道具改变
--**********************************
function x600003_OnItemChanged( sceneId, selfId, itemdataId )
	local misIndex = GetMissionIndexByID( sceneId, selfId, x600003_g_MissionId )

	local _, strItemName, _ = GetItemInfoByItemId( itemdataId )
	local demandItemId = GetMissionParam( sceneId, selfId, misIndex, x600003_g_StrForePart )
	local _, strDemandItemName, _ = GetItemInfoByItemId( demandItemId )

	if strItemName == strDemandItemName then
		local nItemNum = GetItemCount( sceneId, selfId, itemdataId )
		local strText
		if nItemNum > 0 then
			strText = format( "已得到 %s", strItemName )
			SetMissionByIndex( sceneId, selfId, misIndex, x600003_g_IsMissionOkFail, 1 )
		else
			strText = format( "失去 %s", strItemName )
			SetMissionByIndex( sceneId, selfId, misIndex, x600003_g_IsMissionOkFail, 0 )
		end

		CallScriptFunction( x600003_g_CityMissionScript, "NotifyFailTips", sceneId, selfId, strText )
	end
end
