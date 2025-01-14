--生活技能
--健体

--2006-9-18 17:05 (这个文件存在的意义是为了兼容、及扩展，所有真正的判断，都在ecity_lifeskillstudy.lua中实现)
x713625_g_ScriptId 		= 713625
x713625_g_AbilityName	= "健体"
x713625_g_AbilityID		= ABILITY_JIANTI

-- 处理玩家所做的选择
function x713625_OnDefaultEvent( sceneId, selfId, targetId, nNum, npcScriptId, bid )
	if bid then
		if 0 == nNum then	--学习
			if CallScriptFunction( CITY_BUILDING_ABILITY_SCRIPT, "CheckCityStatus",sceneId, selfId,targetId) < 0 then
				return
			end
			BeginEvent(sceneId)
			local lv,money,con
			lv,money,con = CallScriptFunction( CITY_BUILDING_ABILITY_SCRIPT, "OnCityAction",sceneId, selfId, targetId, x713625_g_AbilityID, bid, 4)
			local studyMsg = format("如果你达到%d级并且肯花费#{_EXCHG%d}和%d点帮贡就可以学会健体技能。你决定学习么？", lv, money, con)
			AddText(sceneId,studyMsg)
			--确定学习按钮
					AddNumText(sceneId,x713625_g_ScriptId,"我确定要学习", 6, 3)
			--取消学习按钮
					AddNumText(sceneId,x713625_g_ScriptId,"我只是来看看", 8, 4)
			EndEvent(sceneId)
			DispatchEventList(sceneId,selfId,targetId)
		elseif 1 == nNum then	--升级
			if CallScriptFunction( CITY_BUILDING_ABILITY_SCRIPT, "CheckCityStatus",sceneId, selfId,targetId) < 0 then
				return
			end
			local ret = CallScriptFunction( CITY_BUILDING_ABILITY_SCRIPT, "OnCityCheck",sceneId, selfId, x713625_g_AbilityID, bid, 2)
			if ret > 0 then
				CallScriptFunction( CITY_BUILDING_ABILITY_SCRIPT, "OnCityAction",sceneId, selfId, targetId, x713625_g_AbilityID, bid, 2)
			end
		elseif 2 == nNum then	--了解
			local dialog = "#{event_liveabilityevent_0034}"
			BeginEvent(sceneId)
				AddText(sceneId, dialog)
			EndEvent(sceneId)
			DispatchEventList(sceneId, selfId, targetId)
		elseif 3 == nNum then	--确定学习
			local ret = CallScriptFunction( CITY_BUILDING_ABILITY_SCRIPT, "OnCityCheck",sceneId, selfId, x713625_g_AbilityID, bid, 1)
			if ret > 0 then
				CallScriptFunction( CITY_BUILDING_ABILITY_SCRIPT, "OnCityAction",sceneId, selfId, targetId, x713625_g_AbilityID, bid, 1)
			end
		elseif 4 <= nNum then	--只来看看
			CallScriptFunction( npcScriptId, "OnDefaultEvent",sceneId, selfId, targetId )
		end
	else
		-- 目前健体技能必须在城市里才能学习、升级、了解
	end
end

-- 列举选项
-- nNum == 1 学习
-- nNum == 2 升级
-- nNum == 3 了解
function x713625_OnEnumerate( sceneId, selfId, targetId, bid, nNum)
	if bid then
		if 1 == nNum then
			local ret = CallScriptFunction( CITY_BUILDING_ABILITY_SCRIPT, "OnCityCheck",sceneId, selfId, x713625_g_AbilityID, bid, 5)
			if ret > 0 then AddNumText(sceneId,x713625_g_ScriptId,"学习"..x713625_g_AbilityName.."技能", 12, 0) end
			return
		elseif 2 == nNum then
			local ret = CallScriptFunction( CITY_BUILDING_ABILITY_SCRIPT, "OnCityCheck",sceneId, selfId, x713625_g_AbilityID, bid, 6)
			if ret > 0 then AddNumText(sceneId,x713625_g_ScriptId,"升级"..x713625_g_AbilityName.."技能", 12, 1) end
			return
		elseif 3 == nNum then
			AddNumText(sceneId,x713625_g_ScriptId,"我想了解健体",11,2)
			AddNumText(sceneId,x713625_g_ScriptId,"返回",8,5)
		end
	else
		-- 目前健体技能必须在城市里才能学习、升级、了解
	end
end
