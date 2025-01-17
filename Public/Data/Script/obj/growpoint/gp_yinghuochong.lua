--生长点
--萤火虫
--脚本号712527
--水晶矿石1	0.6		2	0.3		3	0.1		皓石1%
--以20%概率得到副产品20103019,20103031,20103043,20103055 中的一种，数量1	0.6		2	0.3		3	0.1
--等级1

--每次打开必定获得的产品
x712527_g_MainItemId = 30501104
--可能得到的产品
x712527_g_SubItemId = 30501105
--副产品
x712527_g_Byproduct = {20103019,20103031,20103043,20103055}
--需要技能Id
x712527_g_AbilityId = 7
--需要技能等级
x712527_g_AbilityLevel = 0


--生成函数开始************************************************************************
--每个ItemBox中最多10个物品
function 		x712527_OnCreate(sceneId,growPointType,x,y)
	--放入ItemBox同时放入一个物品
	targetId  = ItemBoxEnterScene(x,y,growPointType,sceneId,QUALITY_MUST_BE_CHANGE,1,x712527_g_MainItemId)	--每个生长点最少能得到一个物品,这里直接放入itembox中一个
	--获得1~100的随机数,用来放入主产品和副产品以及次要产品（宝石）
	--主产品1~60不放，61~90放1个，91~100放2个
	--副产品1~12放1个，13~18放2个，19~20放3个
	--次要产品（宝石）1放1个
	local ItemCount = random(1,4);
	for n = 1, ItemCount do
		AddItemToBox(sceneId,targetId,QUALITY_MUST_BE_CHANGE,1,x712527_g_MainItemId)
	end
	
	--放入次要产品
	if random(1,9) == 1 then
		AddItemToBox(sceneId,targetId,QUALITY_MUST_BE_CHANGE,1,x712527_g_SubItemId)
	end
end
--生成函数结束**********************************************************************


--打开前函数开始&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
function	 x712527_OnOpen(sceneId,selfId,targetId)
--返回类型
-- 0 表示打开成功
	ABilityID		=	GetItemBoxRequireAbilityID(sceneId,targetId)
	AbilityLevel = QueryHumanAbilityLevel(sceneId,selfId,ABilityID)
	res = x712527_OpenCheck(sceneId,selfId,ABilityID,AbilityLevel)
	return res
	end
--打开前函数结束&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


--回收函数开始########################################################################
function	 x712527_OnRecycle(sceneId,selfId,targetId)
	-- 增加熟练度
		ABilityID	=	GetItemBoxRequireAbilityID(sceneId,targetId)
	CallScriptFunction(ABILITYLOGIC_ID, "GainExperience", sceneId, selfId, ABilityID, x712527_g_AbilityLevel)
		--返回1，生长点回收
		return 1
end
--回收函数结束########################################################################



--打开后函数开始@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
function	x712527_OnProcOver( sceneId, selfId, targetId )
	--local ABilityID = GetItemBoxRequireAbilityID( sceneId, targetId )
	--CallScriptFunction( ABILITYLOGIC_ID, "EnergyCostCaiJi", sceneId, selfId, ABilityID, x712527_g_AbilityLevel )
	return 0
end
--打开后函数结束@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
function	x712527_OpenCheck(sceneId,selfId,AbilityId,AbilityLevel)
	--检查生活技能等级
	if AbilityLevel<x712527_g_AbilityLevel then
		return OR_NO_LEVEL
	end
	--检查精力
	--if GetHumanEnergy(sceneId,selfId)< (floor(x712527_g_AbilityLevel * 1.5 +2) * 2) then
	--	return OR_NOT_ENOUGH_ENERGY
	--end
	return OR_OK
end

--一次创建多个宝箱的完成函数开始****************************************************
function x712527_OnTickCreateFinish( sceneId, growPointType, tickCount )
	--if(strlen(x712508_g_TickCreate_Msg) > 0) then
	--	--2006-8-22 14:37 等待晓健的server对话平台
	--	print( sceneId .. " 号场景 "..x712508_g_TickCreate_Msg)
	--end
end
--一次创建多个宝箱的完成函数结束****************************************************
