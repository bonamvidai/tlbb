-- 缝纫配方脚本 用于使用技能制造物品
-- *******
-- 缝纫 7 级
-- 该脚本有以下三个必备功能函数：
-- x700932_AbilityCheck ——技能使用检查函数
-- x700932_AbilityConsume ——合成结束，进行相关消耗
-- x700932_AbilityProduce ——合成成功，产出产品

--------------------------------------------------------------------------------
-- 以下部分需要改写
--------------------------------------------------------------------------------
--脚本中文名
--2级帽配方 制造物品

-- 脚本号
x700932_g_ScriptId = 700932

-- 生活技能号
x700932_g_AbilityID = ABILITY_FENGREN

-- 该项生活技能的最大级别
x700932_g_AbilityMaxLevel = 12

-- 配方号
x700932_g_RecipeID = 106

-- 配方等级(需求技能的等级)
x700932_g_RecipeLevel = 7

-- 材料表
x700932_g_CaiLiao = {
	{ID = 20105007, Count = 17},
	{ID = 20107007, Count = 19},
	{ID = 20108103, Count = 26},
	{ID = 20308077, Count = 1},
}

-- 产品表
x700932_g_ChanPin = {
	{ID = 10213018, Odds = 1666},
	{ID = 10213019, Odds = 3332},
	{ID = 10213020, Odds = 4998},
	{ID = 10213021, Odds = 6664},
	{ID = 10213022, Odds = 8330},
	{ID = 10213023, Odds = 10000},
}
--------------------------------------------------------------------------------
-- 以上部分需要改写
--------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
--	技能使用检查函数
----------------------------------------------------------------------------------------
function x700932_AbilityCheck(sceneId, selfId)

	-- 检测背包是不是有空格，没有空格就不能进行
	if LuaFnGetPropertyBagSpace(sceneId, selfId) < 1 then
		return OR_BAG_OUT_OF_SPACE
	end

	-- 检查其他消耗
	VigorValue = x700932_g_RecipeLevel * 2 + 1
	if GetHumanVigor(sceneId, selfId) < VigorValue then
		return OR_NOT_ENOUGH_VIGOR
	end

	-- 检查是否材料足够

	for idx, Mat in x700932_g_CaiLiao do
		nCount = Mat.Count

		ret = LuaFnGetAvailableItemCount(sceneId, selfId, Mat.ID)
		if ret < nCount then
			return OR_STUFF_LACK
		end
	end

	return OR_OK
end

----------------------------------------------------------------------------------------
--	合成结束，进行相关消耗
----------------------------------------------------------------------------------------
function x700932_AbilityConsume(sceneId, selfId)
	-- 首先进行其他消耗
	VigorCost = x700932_g_RecipeLevel * 2 + 1
	VigorValue = GetHumanVigor(sceneId, selfId) - VigorCost
	SetHumanVigor(sceneId, selfId, VigorValue)

	-- 然后进行材料消耗

	for idx, Mat in x700932_g_CaiLiao do
		nCount = Mat.Count

		ret = LuaFnDelAvailableItem(sceneId, selfId, Mat.ID, nCount)
		if ret ~= 1 then
			return 0
		end
	end

	return 1
end

----------------------------------------------------------------------------------------
--	合成成功，产出产品
----------------------------------------------------------------------------------------
function x700932_AbilityProduce(sceneId, selfId)
	AbilityLevel = QueryHumanAbilityLevel(sceneId, selfId, x700932_g_AbilityID)

	-- 随机出一个数 [1, 10000]
	rand = random(10000)

	for i, item in x700932_g_ChanPin do
		if item.Odds >= rand then
			Quality = CallScriptFunction( ABILITYLOGIC_ID, "CalcQuality", sceneId, x700932_g_RecipeLevel, AbilityLevel, x700932_g_AbilityMaxLevel,item.ID )

			local pos = LuaFnTryRecieveItem(sceneId, selfId, item.ID, QUALITY_MUST_BE_CHANGE)
			if pos ~= -1 then
				LuaFnSetItemCreator( sceneId, selfId, pos, LuaFnGetName( sceneId, selfId ) )
			else
				return OR_ERROR
			end

			LuaFnAuditAbility( sceneId, selfId, x700932_g_AbilityID, x700932_g_RecipeID, Quality )
			LuaFnSendAbilitySuccessMsg( sceneId, selfId, x700932_g_AbilityID, x700932_g_RecipeID, item.ID )
			return OR_OK
		end
		LuaFnAuditAbility( sceneId, selfId, x700932_g_AbilityID, x700932_g_RecipeID, 0 )
	end

	return OR_ERROR
end
