-- 城市内政之发展任务主事件脚本
-- 脚本号
x600007_g_ScriptId = 600007

-- 任务号
x600007_g_MissionId = 1106

-- 任务目标npc
x600007_g_Name = "朱世友"

-- 任务文本描述
x600007_g_MissionName = "发展任务"
x600007_g_MissionInfo = "城市内政－发展任务"			--任务描述
x600007_g_MissionTarget = "完成朱世友的任务"			--任务目标
x600007_g_ContinueInfo = "    你的任务还没有完成么？"	--未完成任务的npc对话
x600007_g_MissionComplete = "太谢谢你了"				--完成任务npc说的话

x600007_g_MissionParam_SubId = 1

-- 通用城市任务脚本
x600007_g_CityMissionScript = 600001

-- 子任务表
x600007_g_SubMissionScriptList = { 600008, 600009, 600010, 600011 }

-- 任务奖励
x600007_g_ItemAwardIndexOffset = 10						-- 物品奖励所在表格中的列偏移

x600007_g_MissionRound = MD_CITY_DEVELOPMENT_ROUND		-- 环数
x600007_g_MissionAbandonTime = MD_CITY_DEVELOPMENT_TIME	-- 放弃时间

--**********************************
--任务入口函数
--**********************************
function x600007_OnDefaultEvent( sceneId, selfId, targetId )	--点击该任务后执行此脚本
	if GetName( sceneId, targetId ) ~= x600007_g_Name then		--判断该npc是否是对应任务的npc
		return
	end

	local rand = random( getn(x600007_g_SubMissionScriptList) )
	CallScriptFunction( x600007_g_CityMissionScript, "DoDefaultEvent", sceneId, selfId, targetId, x600007_g_MissionId, x600007_g_SubMissionScriptList[rand] )
end

--**********************************
--列举事件
--**********************************
function x600007_OnEnumerate( sceneId, selfId, targetId )
	if GetName( sceneId, targetId ) ~= x600007_g_Name then								--判断该npc是否是对应任务的npc
		return
	end

	--如果已接任务或满足任务接收条件,则列出任务
	if IsHaveMission( sceneId, selfId, x600007_g_MissionId ) > 0 then
		local misIndex = GetMissionIndexByID( sceneId, selfId, x600007_g_MissionId )
		local subMissionScriptId = GetMissionParam( sceneId, selfId, misIndex, x600007_g_MissionParam_SubId )

		CallScriptFunction( subMissionScriptId, "OnEnumerate", sceneId, selfId, targetId )
	elseif x600007_CheckAccept( sceneId, selfId ) > 0 then
		AddNumText( sceneId, x600007_g_ScriptId, x600007_g_MissionName,4,-1 )
	end
end

--**********************************
--检测接受条件，也供子任务调用
--**********************************
function x600007_CheckAccept( sceneId, selfId )
	local ret = CallScriptFunction( x600007_g_CityMissionScript, "DoCheckAccept", sceneId, selfId, x600007_g_MissionId, x600007_g_MissionAbandonTime )
	return ret
end

--**********************************
--接受，仅供子任务调用设置公共参数
--**********************************
function x600007_OnAccept( sceneId, selfId, targetId, scriptId )
	if GetName( sceneId, targetId ) ~= x600007_g_Name then								--判断该npc是否是对应任务的npc
		return
	end

	CallScriptFunction( x600007_g_CityMissionScript, "DoAccept", sceneId, selfId, scriptId, x600007_g_MissionId, x600007_g_MissionRound )
end

--**********************************
--放弃，仅供子任务调用
--**********************************
function x600007_OnAbandon( sceneId, selfId )
	CallScriptFunction( x600007_g_CityMissionScript, "DoAbandon", sceneId, selfId, x600007_g_MissionId, x600007_g_MissionAbandonTime, x600007_g_MissionRound )
end

--**********************************
--继续
--**********************************
function x600007_OnContinue( sceneId, selfId, targetId )
end

--**********************************
--检测是否可以提交
--**********************************
function x600007_CheckSubmit( sceneId, selfId )
	local ret = CallScriptFunction( x600007_g_CityMissionScript, "DoCheckSubmit", sceneId, selfId, x600007_g_MissionId )
	return ret
end

--**********************************
--提交，仅供子任务调用
--**********************************
function x600007_OnSubmit( sceneId, selfId, targetId, selectRadioId )
	if x600007_CheckSubmit( sceneId, selfId ) == 1 then
		CallScriptFunction( x600007_g_CityMissionScript, "DoSubmit", sceneId, selfId, x600007_g_MissionId, x600007_g_MissionRound )

		-- 经验奖励
		local ExpBonus = CallScriptFunction( x600007_g_CityMissionScript, "CalcExpBonus", sceneId, selfId, x600007_g_MissionRound )
		AddExp( sceneId, selfId, ExpBonus )

		-- 帮会贡献度奖励
		local ContribBonus = CallScriptFunction( x600007_g_CityMissionScript, "CalcContribBonus", sceneId, selfId, x600007_g_MissionRound )
		-- print(ContribBonus)
		if ContribBonus > 0 then
			CityChangeAttr( sceneId, selfId, GUILD_CONTRIB_POINT, ContribBonus )
		end

		-- 专业奖励
		local SpecBonus = CallScriptFunction( x600007_g_CityMissionScript, "CalcSpecBonus", sceneId, selfId, x600007_g_MissionRound )
		-- print(SpecBonus)
		if SpecBonus > 0 then
			CityChangeAttr( sceneId, selfId, GUILD_AGR_LEVEL, SpecBonus )
		end

		-- 物品奖励
		CallScriptFunction( x600007_g_CityMissionScript, "RandomItemAward", sceneId, selfId,
			x600007_g_MissionRound, x600007_g_ItemAwardIndexOffset )
			
			-- 熔炼符奖励
		CallScriptFunction( x600007_g_CityMissionScript, "RandomItemMeltingAward", sceneId, selfId,
			x600007_g_MissionRound )

		-- 统计信息
		LuaFnAuditQuest(sceneId, selfId, x600007_g_MissionName)

		-- 记录玩家完成了一个任务
		CallScriptFunction( x600007_g_CityMissionScript, "MissionComplete", sceneId, selfId)
	end
end

--**********************************
-- 判断某个事件号是否存在于当前事件列表
--**********************************
function x600007_IsInEventList( sceneId, selfId, eventId )
	local i = 1
	local findId = 0

	for i, findId in x600007_g_SubMissionScriptList do
		if eventId == findId then
			return 1
		end
	end

	return 0
end

