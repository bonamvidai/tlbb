--飘渺峰 哈大霸AI

--A 【哪里走】给自己用一个空技能....所有非少林玩家加定身buff....
--B 【悬枢之痛】给自己加不能移动双倍攻击buff....
--C 【气海之痛】给自己加受到伤害加倍buff....
--D 【丝竹空之痛】给自己加被玩家挑衅的buff....
--E 【疯狂】给自己加一击致命buff....

--全程都带有免疫制定技能的buff....
--20秒后开始使用A技能....冷却20秒....
--25秒后开始循环释放BCD技能....冷却分别是20..20..30....
--5分钟后进入狂暴模式....停止使用ABCD....清除ABCD的buff....使用E技能....

--脚本号
x402083_g_ScriptId	= 402083

--副本逻辑脚本号....
x402083_g_FuBenScriptId = 402080

--buff....
x402083_Buff_MianYi1	= 10473	--免疫一些负面效果....
x402083_Buff_MianYi2	= 10471	--免疫普通隐身....
x402083_Skill_A			=	751
x402083_Buff_A			= 9996
x402083_Skill_B			=	1025
x402083_Buff_B			= 10231
x402083_Skill_C			=	750
x402083_Buff_C			= 9995
x402083_Skill_D			=	1027
x402083_Buff_D			= 10233
x402083_Buff_E1			= 10234
x402083_Buff_E2			= 10235

--技能释放时间表....
x402083_UseSkillList =
{
	{ 20,  "A" },
	{ 25,  "B" },
	{ 40,  "A" },
	{ 45,  "C" },
	{ 60,  "A" },
	{ 65,  "D" },
	{ 80,  "A" },
	{ 95,  "B" },
	{ 100, "A" },
	{ 115, "C" },
	{ 120, "A" },
	{ 135, "D" },
	{ 140, "A" },
	{ 160, "A" },
	{ 165, "B" },
	{ 180, "A" },
	{ 185, "C" },
	{ 200, "A" },
	{ 205, "D" },
	{ 220, "A" },
	{ 235, "B" },
	{ 240, "A" },
	{ 255, "C" },
	{ 260, "A" },
	{ 275, "D" },
	{ 280, "A" },
	{ 300, "E" }
}


--AI Index....
x402083_IDX_CombatTime		= 1	--进入战斗的计时器....用于记录已经进入战斗多长时间了....
x402083_IDX_UseSkillIndex	= 2	--接下来该使用技能表中的第几个技能....

x402083_IDX_CombatFlag 			= 1	--是否处于战斗状态的标志....
x402083_IDX_IsKuangBaoMode	= 2	--是否处于狂暴模式的标志....


--**********************************
--初始化....
--**********************************
function x402083_OnInit(sceneId, selfId)
	--重置AI....
	x402083_ResetMyAI( sceneId, selfId )
end


--**********************************
--心跳....
--**********************************
function x402083_OnHeartBeat(sceneId, selfId, nTick)

	--检测是不是死了....
	if LuaFnIsCharacterLiving(sceneId, selfId) ~= 1 then
		return
	end

	--检测是否不在战斗状态....
	if 0 == MonsterAI_GetBoolParamByIndex( sceneId, selfId, x402083_IDX_CombatFlag ) then
		return
	end

	--狂暴状态不需要走逻辑....
	if 1 == MonsterAI_GetBoolParamByIndex( sceneId, selfId, x402083_IDX_IsKuangBaoMode ) then
		return
	end

	--==================================
	--根据节目单释放技能....
	--==================================

	--获得战斗时间和已经执行到技能表中的第几项....
	local CombatTime = MonsterAI_GetIntParamByIndex( sceneId, selfId, x402083_IDX_CombatTime )
	local NextSkillIndex = MonsterAI_GetIntParamByIndex( sceneId, selfId, x402083_IDX_UseSkillIndex )
	--累加进入战斗的时间....
	MonsterAI_SetIntParamByIndex( sceneId, selfId, x402083_IDX_CombatTime, CombatTime + nTick )

	--如果已经执行完整张技能表则不使用技能....
	if NextSkillIndex < 1 or NextSkillIndex > getn( x402083_UseSkillList ) then
		return
	end

	--如果已经到了用这个技能的时间则使用技能....
	local SkillData = x402083_UseSkillList[NextSkillIndex]
	if ( CombatTime + nTick ) >= SkillData[1]*1000 then
		MonsterAI_SetIntParamByIndex( sceneId, selfId, x402083_IDX_UseSkillIndex, NextSkillIndex+1 )
		x402083_UseMySkill( sceneId, selfId, SkillData[2] )
	end


end


--**********************************
--进入战斗....
--**********************************
function x402083_OnEnterCombat(sceneId, selfId, enmeyId)

	--加初始buff....
	LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, selfId, x402083_Buff_MianYi1, 0 )
	LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, selfId, x402083_Buff_MianYi2, 0 )

	--重置AI....
	x402083_ResetMyAI( sceneId, selfId )

	--设置进入战斗状态....
	MonsterAI_SetBoolParamByIndex( sceneId, selfId, x402083_IDX_CombatFlag, 1 )

end


--**********************************
--离开战斗....
--**********************************
function x402083_OnLeaveCombat(sceneId, selfId)

	--重置AI....
	x402083_ResetMyAI( sceneId, selfId )

	--删除自己....
	LuaFnDeleteMonster( sceneId, selfId )

	--创建对话NPC....
	local MstId = CallScriptFunction( x402083_g_FuBenScriptId, "CreateBOSS", sceneId, "HaDaBa_NPC", -1, -1 )
	SetUnitReputationID( sceneId, MstId, MstId, 0 )

end


--**********************************
--杀死敌人....
--**********************************
function x402083_OnKillCharacter(sceneId, selfId, targetId)

end


--**********************************
--死亡....
--**********************************
function x402083_OnDie( sceneId, selfId, killerId )

	--重置AI....
	x402083_ResetMyAI( sceneId, selfId )

	--设置已经挑战过哈大霸....
	CallScriptFunction( x402083_g_FuBenScriptId, "SetBossBattleFlag", sceneId, "HaDaBa", 2 )

	--如果还没有挑战过桑土公则可以挑战桑土公....
	if 2 ~= CallScriptFunction( x402083_g_FuBenScriptId, "GetBossBattleFlag", sceneId, "SangTuGong" ) then
	CallScriptFunction( x402083_g_FuBenScriptId, "SetBossBattleFlag", sceneId, "SangTuGong", 1 )
	end
		
	-- zchw 全球公告
	local	playerName	= GetName( sceneId, killerId )
	
	--杀死怪物的是宠物则获取其主人的名字....
	local playerID = killerId
	local objType = GetCharacterType( sceneId, killerId )
	if objType == 3 then
		playerID = GetPetCreator( sceneId, killerId )
		playerName = GetName( sceneId, playerID )
	end
	
	--如果玩家组队了则获取队长的名字....
	local leaderID = GetTeamLeader( sceneId, playerID )
	if leaderID ~= -1 then
		playerName = GetName( sceneId, leaderID )
	end
	
	if playerName ~= nil then
		str = format("#{_INFOUSR%s}#P在兵圣奇阵#P中与#Y[萧逸风]#P对骂，情急之时给了#Y[萧逸风]#P一记耳光，拳打脚踢......#Y[萧逸风]#P终抵不住，惨死在兵圣奇阵之中。", playerName); --哈大霸
		AddGlobalCountNews( sceneId, str )
	end

end


--**********************************
--重置AI....
--**********************************
function x402083_ResetMyAI( sceneId, selfId )

	--重置参数....
	MonsterAI_SetIntParamByIndex( sceneId, selfId, x402083_IDX_CombatTime, 0 )
	MonsterAI_SetIntParamByIndex( sceneId, selfId, x402083_IDX_UseSkillIndex, 1 )

	MonsterAI_SetBoolParamByIndex( sceneId, selfId, x402083_IDX_IsKuangBaoMode, 0 )
	MonsterAI_SetBoolParamByIndex( sceneId, selfId, x402083_IDX_CombatFlag, 0 )

	--清除buff....
	LuaFnCancelSpecificImpact( sceneId, selfId, x402083_Buff_B )
	LuaFnCancelSpecificImpact( sceneId, selfId, x402083_Buff_C )
	LuaFnCancelSpecificImpact( sceneId, selfId, x402083_Buff_D )
	LuaFnCancelSpecificImpact( sceneId, selfId, x402083_Buff_E1 )
	LuaFnCancelSpecificImpact( sceneId, selfId, x402083_Buff_E2 )

end


--**********************************
--BOSS使用技能....
--**********************************
function x402083_UseMySkill( sceneId, selfId, skill )

	if skill == "A" then

		x402083_SkillA_NaLiZou( sceneId, selfId )

	elseif skill == "B" then

		MonsterTalk(sceneId, -1, "", "#ccc9933[萧逸风]#W哎呦，脚被什么东西扎到了..." )
		local x,z = GetWorldPos( sceneId, selfId )
		LuaFnUnitUseSkill( sceneId, selfId, x402083_Skill_B, selfId, x, z, 0, 0 )
		LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, selfId, x402083_Buff_B, 2000 )

	elseif skill == "C" then

		MonsterTalk(sceneId, -1, "", "#ccc9933[萧逸风]#W休想走，玄冰术伺候..." )
		local x,z = GetWorldPos( sceneId, selfId )
		LuaFnUnitUseSkill( sceneId, selfId, x402083_Skill_C, selfId, x, z, 0, 0 )
		LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, selfId, x402083_Buff_C, 0 )

	elseif skill == "D" then

		local enemyId = GetMonsterCurEnemy( sceneId, selfId )
		if enemyId > 0 then
			if GetCharacterType( sceneId, enemyId ) == 3 then
				enemyId = GetPetCreator( sceneId, enemyId )
			end
			MonsterTalk(sceneId, -1, "", "#ccc9933[萧逸风]#W我怒了..." )
			local x,z = GetWorldPos( sceneId, selfId )
			LuaFnUnitUseSkill( sceneId, selfId, x402083_Skill_D, selfId, x, z, 0, 0 )
			LuaFnSendSpecificImpactToUnit( sceneId, selfId, enemyId, selfId, x402083_Buff_D, 0 )
		end

	elseif skill == "E" then

		MonsterAI_SetBoolParamByIndex( sceneId, selfId, x402083_IDX_IsKuangBaoMode, 1 )
		x402083_SkillE_KuangBao( sceneId, selfId )

	end

end


--**********************************
--哪里走技能....对非少林玩家加buff....
--**********************************
function x402083_SkillA_NaLiZou( sceneId, selfId )

	MonsterTalk(sceneId, -1, "", "#ccc9933[萧逸风]#W哪里逃，定！！！" )

	local nHumanCount = LuaFnGetCopyScene_HumanCount(sceneId)
	for i=0, nHumanCount-1 do

		local nHumanId = LuaFnGetCopyScene_HumanObjId(sceneId, i)
		if LuaFnIsObjValid(sceneId, nHumanId) == 1 and LuaFnIsCanDoScriptLogic(sceneId, nHumanId) == 1 and LuaFnIsCharacterLiving(sceneId, nHumanId) == 1 then
			if GetMenPai(sceneId,nHumanId) ~= MP_SHAOLIN then
				LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, nHumanId, x402083_Buff_A, 0 )
				local x,z = GetWorldPos( sceneId, selfId )
				LuaFnUnitUseSkill( sceneId, selfId, x402083_Skill_A, selfId, x, z, 0, 0 )
			end
		end

	end

end


--**********************************
--狂暴技能....
--**********************************
function x402083_SkillE_KuangBao( sceneId, selfId )

	--取消BCD的buff....
	LuaFnCancelSpecificImpact( sceneId, selfId, x402083_Buff_B )
	LuaFnCancelSpecificImpact( sceneId, selfId, x402083_Buff_C )
	LuaFnCancelSpecificImpact( sceneId, selfId, x402083_Buff_D )

	--加狂暴buff....
	LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, selfId, x402083_Buff_E1, 0 )
	LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, selfId, x402083_Buff_E2, 0 )

end
