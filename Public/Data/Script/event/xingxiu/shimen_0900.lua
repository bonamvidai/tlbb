--找人任务
--韩世忠寻找王彦
--MisDescBegin
--脚本号
x227900_g_ScriptId = 227900

--任务号
x227900_g_MissionId = 1099

--上一个任务的ID
--g_MissionIdPre = 

--目标NPC
x227900_g_Name	="王彦"

--任务归类
x227900_g_MissionKind = 27

--任务等级
x227900_g_MissionLevel = 10

--是否是精英任务
x227900_g_IfMissionElite = 0

--任务名
x227900_g_MissionName="为师门而战"
x227900_g_MissionInfo="#{event_xingxiu_0001}"
x227900_g_MissionTarget="    在星宿海找到王彦#{_INFOAIM96,92,16,王彦}。"
x227900_g_MissionComplete="  你是新来的同门吧，你来得太好了，我这里有很多事情需要你帮忙呢。"
x227900_g_MoneyBonus=800

--MisDescEnd
--**********************************
--任务入口函数
--**********************************
function x227900_OnDefaultEvent( sceneId, selfId, targetId )
    --如果玩家完成过这个任务
    if (IsMissionHaveDone(sceneId,selfId,x227900_g_MissionId) > 0 ) then
    	return
	elseif( IsHaveMission(sceneId,selfId,x227900_g_MissionId) > 0)  then
		if GetName(sceneId,targetId) == x227900_g_Name then
			x227900_OnContinue( sceneId, selfId, targetId )
		end
    --满足任务接收条件
    elseif x227900_CheckAccept(sceneId,selfId) > 0 then
		if GetName(sceneId,targetId) ~= x227900_g_Name then
			--发送任务接受时显示的信息
			BeginEvent(sceneId)
				AddText(sceneId,x227900_g_MissionName)
				AddText(sceneId,x227900_g_MissionInfo)
				AddText(sceneId,"#{M_MUBIAO}")
				AddText(sceneId,x227900_g_MissionTarget)
				AddMoneyBonus( sceneId, x227900_g_MoneyBonus )
			EndEvent( )
			DispatchMissionInfo(sceneId,selfId,targetId,x227900_g_ScriptId,x227900_g_MissionId)
		end
    end
end

--**********************************
--列举事件
--**********************************
function x227900_OnEnumerate( sceneId, selfId, targetId )
	--如果玩家完成过这个任务
	if IsMissionHaveDone(sceneId,selfId,x227900_g_MissionId) > 0 then
		return 
	--如果已接此任务
	elseif IsHaveMission(sceneId,selfId,x227900_g_MissionId) > 0 then
		if GetName(sceneId,targetId) == x227900_g_Name then
			AddNumText(sceneId, x227900_g_ScriptId,x227900_g_MissionName,2,-1);
		end
	--满足任务接收条件
	elseif x227900_CheckAccept(sceneId,selfId) > 0 then
		if GetName(sceneId,targetId) ~= x227900_g_Name then
			AddNumText(sceneId,x227900_g_ScriptId,x227900_g_MissionName,1,-1);
		end
    end
end

--**********************************
--检测接受条件
--**********************************
function x227900_CheckAccept( sceneId, selfId )
	local  MenPai = GetMenPai( sceneId, selfId)
	if	MenPai ~= 5 then
		return 0
	else
		return 1
	end
end

--**********************************
--接受
--**********************************
function x227900_OnAccept( sceneId, selfId )
	--加入任务到玩家列表
	AddMission( sceneId,selfId, x227900_g_MissionId, x227900_g_ScriptId, 0, 0, 0 )
	Msg2Player(  sceneId, selfId,"#Y接受任务：为师门而战",MSG2PLAYER_PARA )
end

--**********************************
--放弃
--**********************************
function x227900_OnAbandon( sceneId, selfId )
	--删除玩家任务列表中对应的任务
    DelMission( sceneId, selfId, x227900_g_MissionId )
end

--**********************************
--继续
--**********************************
function x227900_OnContinue( sceneId, selfId, targetId )
	--提交任务时的说明信息
    BeginEvent(sceneId)
		AddText(sceneId,x227900_g_MissionName)
		AddText(sceneId,x227900_g_MissionComplete)
		AddMoneyBonus( sceneId, x227900_g_MoneyBonus )
    EndEvent( )
    DispatchMissionContinueInfo(sceneId,selfId,targetId,x227900_g_ScriptId,x227900_g_MissionId)
end

--**********************************
--检测是否可以提交
--**********************************
function x227900_CheckSubmit( sceneId, selfId )
	local bRet = CallScriptFunction( SCENE_SCRIPT_ID, "CheckSubmit", sceneId, selfId, x227900_g_MissionId )
	if bRet ~= 1 then
		return 0
	end

	return 1
end

--**********************************
--提交
--**********************************
function x227900_OnSubmit( sceneId, selfId, targetId, selectRadioId )
	if x227900_CheckSubmit( sceneId, selfId, selectRadioId ) == 1 then
		AddMoney(sceneId,selfId,x227900_g_MoneyBonus );
		LuaFnAddExp( sceneId, selfId, 800)
		ret = DelMission( sceneId, selfId, x227900_g_MissionId )
		if ret > 0 then
			MissionCom( sceneId, selfId, x227900_g_MissionId )
			Msg2Player(  sceneId, selfId,"#Y完成任务：为师门而战",MSG2PLAYER_PARA )
		end
	end
end

--**********************************
--杀死怪物或玩家
--**********************************
function x227900_OnKillObject( sceneId, selfId, objdataId )
end

--**********************************
--进入区域事件
--**********************************
function x227900_OnEnterZone( sceneId, selfId, zoneId )
end

--**********************************
--道具改变
--**********************************
function x227900_OnItemChanged( sceneId, selfId, itemdataId )
end
