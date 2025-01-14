--工艺技能升级

--脚本号
x713566_g_ScriptId = 713566

--此npc可以升到的最高等级
x713566_g_MaxLevel = 5

----技能编号
x713566_g_AbilityID = ABILITY_GONGYI

--技能名称
x713566_g_AbilityName = "工艺"

x713566_g_Name1 = "阮星竹"
--**********************************
--任务入口函数
--**********************************
function x713566_OnDefaultEvent( sceneId, selfId, targetId, nNum, npcScriptId, bid )
	--玩家技能的等级
	AbilityLevel = QueryHumanAbilityLevel(sceneId, selfId, x713566_g_AbilityID)
	--玩家加工技能的熟练度
	ExpPoint = GetAbilityExp(sceneId, selfId, x713566_g_AbilityID)
	--任务判断

	--如果还没有学会该生活技能
	if AbilityLevel < 1	then
		BeginEvent(sceneId)
			strText = "你还没有学会"..x713566_g_AbilityName.."技能！"
			AddText(sceneId,strText)
		EndEvent(sceneId)
		DispatchEventList(sceneId,selfId,targetId)
		return
	end
	--如果是在城市中升级
	if bid then
		--检查城市是否处于低维护状态
		if CallScriptFunction( CITY_BUILDING_ABILITY_SCRIPT, "CheckCityStatus",sceneId, selfId,targetId) < 0 then
			return
		end
		local ret = CallScriptFunction( CITY_BUILDING_ABILITY_SCRIPT, "OnCityCheck",sceneId, selfId, x713566_g_AbilityID, bid, 2)
		if ret > 0 then
			CallScriptFunction( CITY_BUILDING_ABILITY_SCRIPT, "OnCityAction",sceneId, selfId, targetId, x713566_g_AbilityID, bid, 2)
		end
		return
	end
	
	local MaxLevel = x713566_g_MaxLevel;
	if GetName(sceneId, targetId) == x713566_g_Name1   then
		MaxLevel = 10;
	end
	
	--如果生活技能等级已经超出该npc所能教的范围
	if AbilityLevel >= MaxLevel then
		BeginEvent(sceneId)
			if GetName(sceneId, targetId) == x713566_g_Name1   then
				strText = "我只能教你1-10级的"..x713566_g_AbilityName.."技能."
			else
			strText = "我只能教你1-5级的"..x713566_g_AbilityName.."技能,请到帮派中或者找工艺造诣更为精湛的#Y阮星竹#G（镜湖#{_INFOAIM108,140,5,阮星竹}）#W学习更高级的"..x713566_g_AbilityName.."。"
			end
			AddText(sceneId,strText)
		EndEvent(sceneId)
		DispatchEventList(sceneId,selfId,targetId)
	else
		--DispatchAbilityInfo(sceneId, selfId, targetId,x713566_g_ScriptId, x713566_g_AbilityID, LEVELUP_ABILITY_GONGYI[AbilityLevel+1].Money, LEVELUP_ABILITY_GONGYI[AbilityLevel+1].HumanExp, LEVELUP_ABILITY_GONGYI[AbilityLevel+1].AbilityExpLimitShow,LEVELUP_ABILITY_GONGYI[AbilityLevel+1].HumanLevelLimit)
		local ret, demandMoney, demandExp, limitAbilityExp, limitAbilityExpShow, currentLevelAbilityExpTop, limitLevel, extraMoney, extraExp = LuaFnGetAbilityLevelUpConfig2(ABILITY_GONGYI, AbilityLevel + 1);
		
		if GetName(sceneId, targetId) == x713566_g_Name1   then
			demandMoney = extraMoney;
			demandExp		=	extraExp;
		end
		
		if ret and ret == 1 then
			DispatchAbilityInfo(sceneId, selfId, targetId,x713566_g_ScriptId, x713566_g_AbilityID, demandMoney, demandExp, limitAbilityExpShow, limitLevel);
		end
	end
end

--**********************************
--列举事件
--**********************************
function x713566_OnEnumerate( sceneId, selfId, targetId, bid )
		if bid then
			local ret = CallScriptFunction( CITY_BUILDING_ABILITY_SCRIPT, "OnCityCheck",sceneId, selfId, x713566_g_AbilityID, bid, 6)
			if ret > 0 then AddNumText(sceneId,x713566_g_ScriptId,"升级"..x713566_g_AbilityName.."技能", 12, 1) end
			return
		end
		--如果不到等级则不显示选项
		--if GetLevel(sceneId,selfId) >= LEVELUP_ABILITY_GONGYI[1].HumanLevelLimit then
		local ret, demandMoney, demandExp, limitAbilityExp, limitAbilityExpShow, currentLevelAbilityExpTop, limitLevel, extraMoney, extraExp = LuaFnGetAbilityLevelUpConfig2(ABILITY_GONGYI, 1);
		if ret and ret == 1 and 1 then
			AddNumText(sceneId,x713566_g_ScriptId,"升级"..x713566_g_AbilityName.."技能", 12, 1)
		end
		return
end

--**********************************
--检测接受条件
--**********************************
function x713566_CheckAccept( sceneId, selfId )
end

--**********************************
--接受
--**********************************
function x713566_OnAccept( sceneId, selfId, x713566_g_AbilityID )
end
